'use strict';

const http = require('node:http');
const vm = require('node:vm');

const port = Number(process.env.PORT || 3000);
const sharedSecret = process.env.WORKFLOW_JS_RUNNER_SECRET;
const callbackUrl = process.env.WORKFLOW_JS_CALLBACK_URL;
const maxBodyBytes = 128 * 1024;
const timeoutMs = Number(process.env.WORKFLOW_JS_TIMEOUT_MS || 3000);

if (!sharedSecret || sharedSecret.length < 32 || !callbackUrl) {
  throw new Error('WORKFLOW_JS_RUNNER_SECRET (32+ chars) and WORKFLOW_JS_CALLBACK_URL are required');
}

const sendJson = (response, status, body) => {
  response.writeHead(status, { 'content-type': 'application/json' });
  response.end(JSON.stringify(body));
};

const callbackAction = async (capability, action, args) => {
  const response = await fetch(callbackUrl, {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ capability, action, args })
  });
  const payload = await response.json();
  if (!response.ok) throw new Error(payload.error || `Action ${action} failed`);
  return payload.result;
};

function actionApi(capability) {
  const actions = [
    'sendEmail', 'generateReport', 'logError', 'logInfo', 'createRecord',
    'updateRecord', 'deleteRecord', 'readRecord', 'createStructure',
    'updateStructure', 'deleteStructure', 'createJob', 'createIndex',
    'loadDataToVariable', 'request', 'checkPermissions', 'externalApiCall',
    'conditionOnly', 'noAction', 'webhookEvent'
  ];

  return Object.freeze(Object.fromEntries(actions.map((action) => [
    action,
    async (args = {}) => {
      if (!args || Array.isArray(args) || typeof args !== 'object') {
        throw new TypeError(`${action} expects an object argument`);
      }
      return callbackAction(capability, action, args);
    }
  ])));
}

async function execute({ script, context, capability }) {
  if (typeof script !== 'string' || script.length === 0 || script.length > 64 * 1024) {
    throw new Error('script must be a non-empty string up to 64KB');
  }

  // vm is intentionally not relied on as a security boundary. The container is
  // the isolation boundary; this context only defines the supported script API.
  const actions = actionApi(capability);
  const sandbox = vm.createContext({
    context: Object.freeze(structuredClone(context)),
    actions,
    // Keep existing scripts concise while retaining the namespaced API for new
    // scripts. Both forms enforce the same callback capability checks.
    ...actions,
    JSON, Math, Date, console: Object.freeze({ log: () => {} })
  }, { codeGeneration: { strings: false, wasm: false } });

  const wrapped = `(async () => { 'use strict'; ${script}\n})()`;
  const value = new vm.Script(wrapped, { filename: 'workflow-script.js' })
    .runInContext(sandbox, { timeout: timeoutMs, breakOnSigint: true });

  const result = await Promise.race([
    value,
    new Promise((_, reject) => setTimeout(() => reject(new Error('Script timed out')), timeoutMs))
  ]);
  return result === undefined ? null : result;
}

http.createServer((request, response) => {
  if (request.method === 'GET' && request.url === '/health') return sendJson(response, 200, { status: 'ok' });
  if (request.method !== 'POST' || request.url !== '/execute') return sendJson(response, 404, { error: 'Not found' });
  if (request.headers.authorization !== `Bearer ${sharedSecret}`) return sendJson(response, 401, { error: 'Unauthorized' });

  let body = '';
  request.on('data', (chunk) => {
    body += chunk;
    if (Buffer.byteLength(body) > maxBodyBytes) request.destroy();
  });
  request.on('end', async () => {
    try {
      sendJson(response, 200, { result: await execute(JSON.parse(body)) });
    } catch (error) {
      sendJson(response, 422, { error: error.message || 'Script execution failed' });
    }
  });
}).listen(port, '0.0.0.0');
