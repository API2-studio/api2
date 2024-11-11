import{d as Z}from"./vuedraggable.umd-fe5c4fde.js";import{a3 as A,aO as D,bd as B,aQ as q,a5 as d,a6 as i,ad as t,aH as v,aI as x,aB as h,aK as u,aN as k,aW as M,bb as N,aD as f,aA as S,b6 as j,be as V,a4 as _,aM as g,aV as z,b2 as L,a7 as C,ae as m,aY as w,am as T}from"./index-23c7cbd5.js";const P=(r,e)=>N.filter(r,e),U={props:{table_id:{type:String,required:!0},encoded:{type:String,required:!1},schema:{type:Array,required:!1,default:void 0},script:{type:String,required:!1},columns:{type:Array,required:!1,default:()=>[]},search:{type:String,required:!1,default:""}},data:()=>({showModal:!1,json_column:{},tableName:"",rows:[],totalEntries:0,totalPages:0,currentPage:1,pageSize:10,pageNumber:1,noData:!1,error:{},errors:{}}),computed:{filteredRecords(){if(this.search==="")return this.rows;{let r=P(this.rows.map(e=>`${e.name}-${e.id}-${e.description}`),this.search);return this.rows.filter(e=>r.includes(e.name+"-"+e.id+"-"+e.description))}},titleCase(){return r=>r.toLowerCase().split("_").map(e=>e.charAt(0).toUpperCase()+e.slice(1)).join(" ")},columnOrder(){return["id",...this.columns.map(r=>r.name)]}},components:{},methods:{columnId(r){return r==="id"},isNull(r){return r===null},goToRecord(r){this.$router.push({name:"Record",params:{id:r}})},openJsonModal(r,e){const n=D();n.$patch({json:r}),n.$patch({title:e})},startsWithPbkdf2(r){return typeof r=="string"&&r.startsWith("$pbkdf2")},isTimestamp(r){return/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?(Z|(\+\d{2}:\d{2}))$/.test(r)},isUUID(r){return/^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[14][0-9a-fA-F]{3}-[89ab][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$/.test(r)},isObject(r){return typeof r=="object"&&r!==null},getTable(){let r={id:this.table_id,encoded:this.encoded,script:this.script,page:this.pageNumber,page_size:this.pageSize};console.log(r),B(r).then(e=>{e.data&&e.data.length===0?(this.setNoDataMessage(),this.noData=!0):(console.table(e),this.rows=e.data,this.totalEntries=e.meta.total_entries,this.totalPages=e.meta.total_pages,this.currentPage=e.meta.page_number,this.pageSize=e.meta.page_size,this.tableName=e.name,this.noData=!1)}).catch(e=>{this.noData=!0,this.errors=e,console.error(e)})},setNoDataMessage(){const r=q();r.$patch({message:"No data found",error:"No data found",status:404,multiple:!1,messages:[]}),this.errors=r.$state}},mounted(){this.getTable(),q().$subscribe(e=>{this.error=e.payload})},watch:{pageNumber:function(r){this.pageNumber=r,this.getTable()},pageSize:function(r){this.pageSize=r,this.getTable()},totalPages:function(r){this.totalPages=r,this.getTable()}}},E={class:"max-w-screen min-w-screen"},F={key:0,class:"text-sm text-left text-pickled-500 dark:text-pickled-400 m-5 w-full table-width-less-aside table-auto"},H={class:"text-xs text-pickled-500 uppercase bg-rock-blue-200 dark:bg-pickled-900 dark:text-pickled-200 sticky table-sticky z-20"},I={key:0,class:"whitespace-nowrap"},O=t("th",{scope:"col",class:"p-4 whitespace-nowrap"},[t("div",{class:"flex items-center"},[t("input",{id:"checkbox-all-search",type:"checkbox",class:"w-4 h-4 text-pickled-600 bg-rock-blue-100 border-rock-blue-300 rounded focus:ring-pickled-500 dark:focus:ring-pickled-600 dark:ring-offset-pickled-800 dark:focus:ring-offset-pickled-800 focus:ring-2 dark:bg-pickled-700 dark:border-pickled-600"}),t("label",{for:"checkbox-all-search",class:"sr-only"},"checkbox")])],-1),R=t("td",{class:"order-1 w-4 p-4"},[t("div",{class:"flex items-center"},[t("input",{id:"checkbox-all-search",type:"checkbox",class:"w-4 h-4 text-pickled-600 bg-rock-blue-100 border-rock-blue-300 rounded focus:ring-pickled-500 dark:focus:ring-pickled-600 dark:ring-offset-pickled-800 dark:focus:ring-offset-pickled-800 focus:ring-2 dark:bg-pickled-700 dark:border-pickled-600"}),t("label",{for:"checkbox-table-search-1",class:"sr-only"},"checkbox")])],-1),K={key:0,class:"flex items-center space-x-2"},W=["onClick"],J=["onClick"],Q={class:"flex bg-surf-400 dark:bg-pickled-700 text-pickled-800 dark:text-white rounded-full px-4 py-2 max-w-[100px] overflow-clip"},Y={class:"text-xs overflow-hidden whitespace-nowrap overflow-ellipsis"},G={key:2,class:"hover:text-rock-blue-500 cursor-pointer"},X=t("div",{class:"flex bg-bright-sun-200 dark:bg-bright-sun-400 text-pickled-600 dark:text-pickled-800 rounded-full px-4 py-2 max-w-[140px] overflow-clip"},[t("span",{class:"text-xs overflow-hidden whitespace-nowrap overflow-ellipsis"}," ***REDACTED*** ")],-1),$=[X],ee={key:3,class:"hover:text-rock-blue-500 cursor-pointer"},te=t("div",null,[t("span",null," - ")],-1),re=[te],le={key:4},se={key:5},oe={key:1,role:"status",class:"max-w-screen mx-5 mb-5 p-4 mt-10 space-y-4 border border-gray-200 divide-y divide-gray-200 rounded shadow animate-pulse dark:divide-gray-700 md:p-6 dark:border-gray-700"},de=f('<div class="flex items-center justify-between"><div><div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-600 w-24 mb-2.5"></div><div class="w-32 h-2 bg-gray-200 rounded-full dark:bg-gray-700"></div></div><div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-700 w-12"></div></div><div class="flex items-center justify-between pt-4"><div><div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-600 w-24 mb-2.5"></div><div class="w-32 h-2 bg-gray-200 rounded-full dark:bg-gray-700"></div></div><div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-700 w-12"></div></div><div class="flex items-center justify-between pt-4"><div><div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-600 w-24 mb-2.5"></div><div class="w-32 h-2 bg-gray-200 rounded-full dark:bg-gray-700"></div></div><div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-700 w-12"></div></div><div class="flex items-center justify-between pt-4"><div><div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-600 w-24 mb-2.5"></div><div class="w-32 h-2 bg-gray-200 rounded-full dark:bg-gray-700"></div></div><div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-700 w-12"></div></div><div class="flex items-center justify-between pt-4"><div><div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-600 w-24 mb-2.5"></div><div class="w-32 h-2 bg-gray-200 rounded-full dark:bg-gray-700"></div></div><div class="h-2.5 bg-gray-300 rounded-full dark:bg-gray-700 w-12"></div></div><span class="sr-only">Loading...</span>',6),ie=[de],ae={key:2,class:"flex flex-col items-start ml-5 mb-5"},ce={class:"text-sm text-gray-700 dark:text-gray-400"},ne={class:"font-semibold text-gray-900 dark:text-white"},he={class:"font-semibold text-gray-900 dark:text-white"},ue={class:"font-semibold text-gray-900 dark:text-white"},ke={class:"inline-flex mt-2 xs:mt-0"},be=t("svg",{class:"w-3.5 h-3.5 mr-2","aria-hidden":"true",xmlns:"http://www.w3.org/2000/svg",fill:"none",viewBox:"0 0 14 10"},[t("path",{stroke:"currentColor","stroke-linecap":"round","stroke-linejoin":"round","stroke-width":"2",d:"M13 5H1m0 0l4-4m-4 4l4 4"})],-1),pe=t("svg",{class:"w-3.5 h-3.5 ml-2","aria-hidden":"true",xmlns:"http://www.w3.org/2000/svg",fill:"none",viewBox:"0 0 14 10"},[t("path",{stroke:"currentColor","stroke-linecap":"round","stroke-linejoin":"round","stroke-width":"2",d:"M1 5h12m0 0L9 1m4 4L9 9"})],-1);function ge(r,e,n,p,o,l){return d(),i("div",E,[r.noData?u("",!0):(d(),i("table",F,[t("thead",H,[r.noData?u("",!0):(d(),i("tr",I,[O,(d(!0),i(v,null,x(l.columnOrder,a=>(d(),i("th",{scope:"col",class:"px-6 py-3 whitespace-nowrap",key:a},h(l.titleCase(a)),1))),128))]))]),t("tbody",null,[(d(!0),i(v,null,x(l.filteredRecords,a=>(d(),i("tr",{class:"bg-white border-b dark:bg-pickled-800 dark:border-pickled-700",key:a},[R,(d(!0),i(v,null,x(l.columnOrder,c=>(d(),i("td",{class:"px-6 py-4 max-w-sm overflow-hidden overflow-ellipsis text-pickled-800 dark:text-pickled-200",key:c},[l.isObject(a[c])?(d(),i("div",K,[t("div",{onClick:y=>l.openJsonModal(a[c],c),class:"bg-rock-blue-400 dark:bg-pickled-900 dark:border-rock-blue-900 text-pickled-800 dark:text-pickled-200 px-4 py-2 rounded-full text-xs cursor-pointer"}," Object... ",8,W)])):l.isUUID(a[c])?(d(),i("div",{key:1,class:"hover:text-rock-blue-500 cursor-pointer",onClick:y=>l.goToRecord(a[c])},[t("div",Q,[t("span",Y," ID - "+h(a[c]),1)])],8,J)):l.startsWithPbkdf2(a[c])?(d(),i("div",G,$)):l.isNull(a[c])?(d(),i("div",ee,re)):l.isTimestamp(a[c])?(d(),i("div",le,h(new Date(a[c]).toLocaleString()),1)):(d(),i("div",se,h(a[c]),1))]))),128))]))),128))])])),r.noData?(d(),i("div",oe,ie)):u("",!0),r.noData?u("",!0):(d(),i("div",ae,[t("span",ce,[k(" Showing page "),t("span",ne,h(r.currentPage),1),k(" with "),t("span",he,h(r.pageSize),1),k(" of "),t("span",ue,h(r.totalEntries),1),k(" records ")]),t("div",ke,[r.currentPage>1?(d(),i("button",{key:0,onClick:e[0]||(e[0]=a=>r.pageNumber--),class:"flex items-center justify-center px-4 h-8 text-sm font-medium text-white bg-rock-blue-400 border-0 border-r border-rock-blue-100 rounded-l hover:bg-rock-blue-500 dark:bg-pickled-800 dark:border-pickled-500 dark:text-rock-blue-400 dark:hover:bg-pickled-700 dark:hover:text-white"},[be,k(" Prev ")])):u("",!0),r.currentPage<r.totalPages?(d(),i("button",{key:1,onClick:e[1]||(e[1]=a=>r.pageNumber=r.pageNumber+1),class:M([r.currentPage<r.totalPages?"border-r border-l border-rock-blue-100 rounded-l":"","flex items-center justify-center px-4 h-8 text-sm font-medium text-white bg-rock-blue-400 border-0 border-l border-rock-blue-100 rounded-r hover:bg-rock-blue-500 dark:bg-pickled-800 dark:border-pickled-500 dark:text-rock-blue-400 dark:hover:bg-pickled-700 dark:hover:text-white"])},[k(" Next "),pe],2)):u("",!0)])]))])}const fe=A(U,[["render",ge]]);const me={components:{TableComponent:fe,draggable:Z},computed:{encodedForALL(){return""},encodedForNone(){return`queryType=condition^%${this.tableName}.deleted_at=null^%${this.tableName}.archived_at=null`},encodedToHideDeleted(){return`queryType=condition^%${this.tableName}.deleted_at=null`},encodedToHideArchived(){return`queryType=condition^%${this.tableName}.archived_at=null`},encodedToShowDeleted(){return`queryType=condition^%${this.tableName}.deleted_at!=null`},encodedToShowArchived(){return`queryType=condition^%${this.tableName}.archived_at!=null`},showAll(){return this.showDeleted&&this.showArchived},showNone(){return!this.showDeleted&&!this.showArchived},upperCaseTableName(){return this.tableName.toUpperCase()},titleCase(){return r=>r.toLowerCase().split("_").map(e=>e.charAt(0).toUpperCase()+e.slice(1)).join(" ")},requestSchema(){let r=[];return this.columns.forEach(e=>{if(e.checked){let n={};n.name=e.name,n.field=this.tableStructure.name+"."+e.name,r.push(n)}}),r},processedColumns(){let r=[];return this.columns.forEach(e=>{e.checked&&r.push(e)}),r},isBase(){return this.isBaseTable},table(){return this.$route.params.id},items(){return[{name:"Home",route:"/",label:"Home",order:1},{name:"Tables",route:"/tables",label:"Tables",order:2},{name:"Table",route:`/tables/${this.table}`,label:"Table",order:3}]}},data(){return{noData:!1,tableStructure:{},toggleActions:!1,toggleColumns:!1,columns:[],isBaseTable:!1,encoded:"",script:"",searchTerm:"",tableName:"",showDeleted:!0,showArchived:!0,key:0}},created(){S().getTables(),this.getStructure(this.table)},mounted(){this.checkIfBase(this.table)},methods:{checkIfBase(r){const e={};e.id=r,j(e).then(n=>{this.isBaseTable=n.data.base})},getStructure(r){V({id:r}).then(n=>{console.log(n),this.tableStructure=n,this.tableName=n.name;let p=[];this.columns=this.tableStructure.schema.forEach(o=>{if(o.name!=="id"&&o.name!=="acl"){let l={};l.name=o.name,l.id=o.id,l.checked=!0,p.push(l);for(let a=0;a<p.length;a++)p[a].id=a}}),this.columns=p})},goToTable(r){this.$router.push(`/tables/${r}/create`)},selectAllColumns(){this.columns.forEach(r=>{r.checked=!0})},unselectAll(){this.columns.forEach(r=>{r.checked=!1})},uncheckSelectAllButton(){let r=!0;this.columns.forEach(e=>{e.checked||(r=!1)}),r?this.$refs.selectAll.checked=!0:this.$refs.selectAll.checked=!1},closeActionsMenu(){this.toggleActions=!1},closeColumnsMenu(){this.toggleColumns=!1},toggleAction(){this.toggleActions=!this.toggleActions,this.toggleColumns=!1},toggleColumn(){this.toggleColumns=!this.toggleColumns,this.toggleActions=!1},toggleDeleted(){this.toggleActions=!1,this.toggleColumns=!1,this.showDeleted=!this.showDeleted,this.key++},toggleArchioved(){this.toggleActions=!1,this.toggleColumns=!1,this.showArchived=!this.showArchived,this.key++}}},we={class:"w-screen"},ve={class:"pl-5 w-full max-w-xl flex px-5 py-5","aria-label":"Breadcrumb"},xe={class:"inline-flex items-center space-x-1 md:space-x-3"},ye=t("svg",{"aria-hidden":"true",class:"w-4 h-4 mr-2",fill:"currentColor",viewBox:"0 0 20 20",xmlns:"http://www.w3.org/2000/svg"},[t("path",{d:"M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z"})],-1),_e=t("svg",{xmlns:"http://www.w3.org/2000/svg",width:"20",height:"20",viewBox:"0 0 20 20",fill:"none",stroke:"currentColor","stroke-width":"2","stroke-linecap":"round","stroke-linejoin":"round",class:"feather feather-chevron-right w-4 h-4 mr-2"},[t("polyline",{points:"9 18 15 12 9 6"})],-1),Te={class:"dark:text-pickled-400 text-xl mb-2 mt-0 pl-5"},qe={key:0,id:"table-search",class:"mx-5 flex justify-start pt-2 overflow-x-scroll sm:overflow-x-visible"},Le={class:"flex"},Ce=t("label",{for:"table-search",class:"sr-only"},"Search",-1),Ae=t("div",{class:"absolute z-10 inset-x-5 inset-y-4 left-0 flex items-center pl-3 pointer-events-none"},[t("svg",{class:"w-4 h-4 text-pickled-500 dark:text-pickled-400","aria-hidden":"true",fill:"currentColor",viewBox:"0 0 32 32",xmlns:"http://www.w3.org/2000/svg"},[t("path",{d:"M 5 4 L 5 6.34375 L 5.21875 6.625 L 13 16.34375 L 13 28 L 14.59375 26.8125 L 18.59375 23.8125 L 19 23.5 L 19 16.34375 L 26.78125 6.625 L 27 6.34375 L 27 4 Z M 7.28125 6 L 24.71875 6 L 17.53125 15 L 14.46875 15 Z M 15 17 L 17 17 L 17 22.5 L 15 24 Z"})])],-1),Me=t("span",{class:"sr-only opacity-5"},"Open options",-1),Ze=t("svg",{class:"w-2 h-2 ml-2 -mr-0 mt-1.5 text-pickled-500 dark:text-pickled-400","aria-hidden":"true",xmlns:"http://www.w3.org/2000/svg",fill:"none",viewBox:"0 0 10 6"},[t("path",{stroke:"currentColor","stroke-linecap":"round","stroke-linejoin":"round","stroke-width":"2",d:"m1 1 4 4 4-4"})],-1),De={key:0,id:"dropdownAction",class:"z-30 bg-white divide-y divide-pickled-100 rounded-lg shadow w-56 left-1/2 right-1/2 top-10 dark:bg-pickled-800 dark:divide-pickled-600 absolute mt-2 hidden sm:block"},Be={class:"py-1 text-sm text-pickled-700 dark:text-pickled-200","aria-labelledby":"dropdownActionButton"},Ne=f('<li class="flex justify-between px-4 py-1 hover:bg-pickled-100 border-b border-rock-blue-300 dark:border-rock-blue-800 dark:hover:bg-pickled-600 dark:hover:text-white"><a href="#">Delete</a><svg class="w-4 my-1 h-4 text-pickled-500" aria-hidden="true" fill="currentColor" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><path d="M 6 4 L 6 6 L 26 6 L 26 4 Z M 8 8 L 8 26 L 24 26 L 24 8 Z M 10 10 L 22 10 L 22 24 L 10 24 Z M 12 12 L 12 22 L 20 22 L 20 12 Z M 14 14 L 18 14 L 18 20 L 14 20 Z"></path></svg></li><li class="flex justify-between px-4 py-1 hover:bg-pickled-100 border-b border-rock-blue-300 dark:border-rock-blue-800 dark:hover:bg-pickled-600 dark:hover:text-white"><a href="#">Archive</a><svg class="w-4 my-1 h-4 text-pickled-500" aria-hidden="true" fill="currentColor" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><path d="M 6 4 L 6 6 L 26 6 L 26 4 Z M 8 8 L 8 26 L 24 26 L 24 8 Z M 10 10 L 22 10 L 22 24 L 10 24 Z M 12 12 L 12 22 L 20 22 L 20 12 Z M 14 14 L 18 14 L 18 20 L 14 20 Z"></path></svg></li>',2),Se={class:"flex justify-between px-4 py-1 hover:bg-pickled-100 dark:hover:bg-pickled-600 dark:hover:text-white"},je=t("a",{href:"#"},"Copy IDs",-1),Ve=t("path",{d:"M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"},null,-1),ze=t("rect",{x:"8",y:"2",width:"7",height:"4",å:"",rx:"1",ry:"1"},null,-1),Pe=[Ve,ze],Ue=t("span",{class:"sr-only opacity-5"},"Open options",-1),Ee=t("svg",{class:"w-2 h-2 ml-2 -mr-0 mt-1.5 text-pickled-500 dark:text-pickled-400","aria-hidden":"true",xmlns:"http://www.w3.org/2000/svg",fill:"none",viewBox:"0 0 10 6"},[t("path",{stroke:"currentColor","stroke-linecap":"round","stroke-linejoin":"round","stroke-width":"2",d:"m1 1 4 4 4-4"})],-1),Fe={key:1,id:"dropdownColumns",class:"z-30 bg-white divide-y divide-pickled-100 left-2/3 right-1/3 top-10 rounded-lg shadow w-56 dark:bg-pickled-800 dark:divide-pickled-600 absolute mt-2 hidden sm:block"},He={class:"py-1 text-sm text-pickled-700 dark:text-pickled-200","aria-labelledby":"dropdownActionButton"},Ie={class:"flex justify-between px-4 py-1 hover:bg-pickled-100 border-b border-rock-blue-300 dark:border-rock-blue-800 dark:hover:bg-pickled-600 dark:hover:text-white"},Oe=f('<li class="flex justify-between px-4 py-1 hover:bg-pickled-100 border-b border-rock-blue-300 dark:border-rock-blue-800 dark:hover:bg-pickled-600 dark:hover:text-white"><svg class="w-4 my-1 h-4 text-pickled-500" xmlns="http://www.w3.org/2000/svg" height="16" viewBox="0 -960 960 960" width="16"><path class="fill-current" d="M360-160q-33 0-56.5-23.5T280-240q0-33 23.5-56.5T360-320q33 0 56.5 23.5T440-240q0 33-23.5 56.5T360-160Zm240 0q-33 0-56.5-23.5T520-240q0-33 23.5-56.5T600-320q33 0 56.5 23.5T680-240q0 33-23.5 56.5T600-160ZM360-400q-33 0-56.5-23.5T280-480q0-33 23.5-56.5T360-560q33 0 56.5 23.5T440-480q0 33-23.5 56.5T360-400Zm240 0q-33 0-56.5-23.5T520-480q0-33 23.5-56.5T600-560q33 0 56.5 23.5T680-480q0 33-23.5 56.5T600-400ZM360-640q-33 0-56.5-23.5T280-720q0-33 23.5-56.5T360-800q33 0 56.5 23.5T440-720q0 33-23.5 56.5T360-640Zm240 0q-33 0-56.5-23.5T520-720q0-33 23.5-56.5T600-800q33 0 56.5 23.5T680-720q0 33-23.5 56.5T600-640Z"></path></svg><p class="flex-auto pl-2">id</p><input type="checkbox" class="form-checkbox h-5 w-5 text-pickled-600" disabled checked></li>',1),Re={class:"item flex justify-between px-4 py-1 hover:bg-pickled-100 border-b border-rock-blue-300 dark:border-rock-blue-800 dark:hover:bg-pickled-600 dark:hover:text-white"},Ke=t("svg",{class:"handle cursor-move w-4 my-1 h-4 text-pickled-500",xmlns:"http://www.w3.org/2000/svg",height:"16",viewBox:"0 -960 960 960",width:"16"},[t("path",{class:"fill-current",d:"M360-160q-33 0-56.5-23.5T280-240q0-33 23.5-56.5T360-320q33 0 56.5 23.5T440-240q0 33-23.5 56.5T360-160Zm240 0q-33 0-56.5-23.5T520-240q0-33 23.5-56.5T600-320q33 0 56.5 23.5T680-240q0 33-23.5 56.5T600-160ZM360-400q-33 0-56.5-23.5T280-480q0-33 23.5-56.5T360-560q33 0 56.5 23.5T440-480q0 33-23.5 56.5T360-400Zm240 0q-33 0-56.5-23.5T520-480q0-33 23.5-56.5T600-560q33 0 56.5 23.5T680-480q0 33-23.5 56.5T600-400ZM360-640q-33 0-56.5-23.5T280-720q0-33 23.5-56.5T360-800q33 0 56.5 23.5T440-720q0 33-23.5 56.5T360-640Zm240 0q-33 0-56.5-23.5T520-720q0-33 23.5-56.5T600-800q33 0 56.5 23.5T680-720q0 33-23.5 56.5T600-640Z"})],-1),We={class:"flex-auto pl-2",href:"#"},Je=["onUpdate:modelValue"],Qe={class:"flex"},Ye={class:"flex-shrink inline-flex items-center cursor-pointer pl-3"},Ge=t("div",{class:"w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-rock-blue-300 dark:peer-focus:ring-rock-blue-800 rounded-full peer dark:bg-pickled-700 peer-checked:after:translate-x-full peer-checked:after:border-rock-blue-100 after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-rock-blue-100 after:border-pickled-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-pickled-600 peer-checked:bg-rock-blue-600"},null,-1),Xe=t("span",{class:"ml-3 text-sm font-medium text-gray-900 dark:text-gray-300"},"Show Deleted",-1),$e={class:"flex"},et={class:"flex-shrink inline-flex items-center cursor-pointer pl-3"},tt=t("div",{class:"w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-rock-blue-300 dark:peer-focus:ring-rock-blue-800 rounded-full peer dark:bg-pickled-700 peer-checked:after:translate-x-full peer-checked:after:border-rock-blue-100 after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-rock-blue-100 after:border-pickled-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-pickled-600 peer-checked:bg-rock-blue-600"},null,-1),rt=t("span",{class:"ml-3 text-sm font-medium text-gray-900 dark:text-gray-300"},"Show Archived",-1),lt={key:1,id:"optionsColumnsMobile",class:"z-30 bg-white divide-y divide-pickled-100 rounded-lg shadow ml-5 w-11/12 dark:bg-pickled-800 dark:divide-pickled-600 absolute mt-2 sm:hidden"},st={class:"py-1 text-sm text-pickled-700 dark:text-pickled-200","aria-labelledby":"dropdownActionButton"},ot={class:"flex justify-between px-4 py-1 hover:bg-pickled-100 border-b border-rock-blue-300 dark:border-rock-blue-800 dark:hover:bg-pickled-600 dark:hover:text-white"},dt=f(`<li class="flex justify-between px-4 py-1 hover:bg-pickled-100 border-b border-rock-blue-300 dark:border-rock-blue-800 dark:hover:bg-pickled-600 dark:hover:text-white"><svg class="w-4 my-1 h-4 text-pickled-500" xmlns="http://www.w3.org/2000/svg" height="16" viewBox="0 -960 960 960" width="16"><path class="fill-current" d="M360-160q-33 0-56.5-23.5T280-240q0-33 23.5-56.5T360-320q33 0 56.5 23.5T440-240q0 33-23.5 56.5T360-160Zm240 0q-33 0-56.5-23.5T520-240q0-33 23.5-56.5T600-320q33 0 56.5 23.5T680-240q0 33-23.5 56.5T600-160ZM360-400q-33 0-56.5-23.5T280-480q0-33 23.5-56.5T360-560q33 0 56.5 23.5T440-480q0 33-23.5 56.5T360-400Zm240 0q-33 0-56.5-23.5T520
            -480q0-33 23.5-56.5T600-560q33 0 56.5 23.5T680-480q0 33-23.5 56.5T600-400ZM360-640q-33 0-56.5-23.5T280-720q0-33 23.5-56.5T360-800q33 0 56.5 23.5T440-720q0 33-23.5 56.5T360-640Zm240 0q-33 0-56.5-23.5T520-720q0-33 23.5-56.5T600-800q33 0 56.5 23.5T680-720q0 33-23.5 56.5T600-640Z"></path></svg><p class="flex-auto pl-2">id</p><input type="checkbox" class="form-checkbox h-5 w-5 text-pickled-600" disabled checked></li>`,1),it={class:"item flex justify-between px-4 py-1 hover:bg-pickled-100 border-b border-rock-blue-300 dark:border-rock-blue-800 dark:hover:bg-pickled-600 dark:hover:text-white"},at=t("svg",{class:"handle cursor-move w-4 my-1 h-4 text-pickled-500",xmlns:"http://www.w3.org/2000/svg",height:"16",viewBox:"0 -960 960 960",width:"16"},[t("path",{class:"fill-current",d:"M360-160q-33 0-56.5-23.5T280-240q0-33 23.5-56.5T360-320q33 0 56.5 23.5T440-240q0 33-23.5 56.5T360-160Zm240 0q-33 0-56.5-23.5T520-240q0-33 23.5-56.5T600-320q33 0 56.5 23.5T680-240q0 33-23.5 56.5T600-160ZM360-400q-33 0-56.5-23.5T280-480q0-33 23.5-56.5T360-560q33 0 56.5 23.5T440-480q0 33-23.5 56.5T360-400Zm240 0q-33 0-56.5-23.5T520-480q0-33 23.5-56.5T600-560q33 0 56.5 23.5T680-480q0 33-23.5 56.5T600-400ZM360-640q-33 0-56.5-23.5T280-720q0-33 23.5-56.5T360-800q33 0 56.5 23.5T440-720q0 33-23.5 56.5T360-640Zm240 0q-33 0-56.5-23.5T520-720q0-33 23.5-56.5T600-800q33 0 56.5 23.5T680-720q0 33-23.5 56.5T600-640Z"})],-1),ct={class:"flex-auto pl-2",href:"#"},nt=["onUpdate:modelValue"],ht={key:2,id:"mobileActionsModal",class:"z-30 bg-white divide-y divide-pickled-100 rounded-lg shadow ml-5 w-11/12 dark:bg-pickled-800 dark:divide-pickled-600 absolute mt-2 sm:hidden"},ut={class:"py-1 text-sm text-pickled-700 dark:text-pickled-200","aria-labelledby":"dropdownActionButton"},kt=f('<li class="flex justify-between px-4 py-1 hover:bg-pickled-100 border-b border-rock-blue-300 dark:border-rock-blue-800 dark:hover:bg-pickled-600 dark:hover:text-white"><a href="#">Delete</a><svg class="w-4 my-1 h-4 text-pickled-500" aria-hidden="true" fill="currentColor" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><path d="M 6 4 L 6 6 L 26 6 L 26 4 Z M 8 8 L 8 26 L 24 26 L 24 8 Z M 10 10 L 22 10 L 22 24 L 10 24 Z M 12 12 L 12 22 L 20 22 L 20 12 Z M 14 14 L 18 14 L 18 20 L 14 20 Z"></path></svg></li><li class="flex justify-between px-4 py-1 hover:bg-pickled-100 border-b border-rock-blue-300 dark:border-rock-blue-800 dark:hover:bg-pickled-600 dark:hover:text-white"><a href="#">Archive</a><svg class="w-4 my-1 h-4 text-pickled-500" aria-hidden="true" fill="currentColor" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><path d="M 6 4 L 6 6 L 26 6 L 26 4 Z M 8 8 L 8 26 L 24 26 L 24 8 Z M 10 10 L 22 10 L 22 24 L 10 24 Z M 12 12 L 12 22 L 20 22 L 20 12 Z M 14 14 L 18 14 L 18 20 L 14 20 Z"></path></svg></li>',2),bt={class:"flex justify-between px-4 py-1 hover:bg-pickled-100 dark:hover:bg-pickled-600 dark:hover:text-white"},pt=t("a",{href:"#"},"Copy IDs",-1),gt=t("path",{d:"M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"},null,-1),ft=t("rect",{x:"8",y:"2",width:"7",height:"4",å:"",rx:"1",ry:"1"},null,-1),mt=[gt,ft],wt={class:"flex justify-start ml-5"},vt=["disabled"],xt={key:0,class:"pt-2 pl-5"};function yt(r,e,n,p,o,l){const a=_("router-link"),c=_("draggable"),y=_("TableComponent");return d(),i("div",we,[t("nav",ve,[t("ol",xe,[(d(!0),i(v,null,x(l.items,s=>(d(),i("li",{class:"inline-flex items-center",key:s.order},[s.name==="Home"?(d(),T(a,{key:0,to:s.route,class:"inline-flex items-center text-sm font-medium text-pickled-700 hover:text-rock-blue-600 dark:text-pickled-400 dark:hover:text-rock-blue-50"},{default:m(()=>[ye,k(" "+h(s.label),1)]),_:2},1032,["to"])):(d(),T(a,{key:1,to:s.route,class:"inline-flex items-center text-sm font-medium text-pickled-700 hover:text-rock-blue-600 dark:text-pickled-400 dark:hover:text-rock-blue-50"},{default:m(()=>[_e,k(" "+h(s.label),1)]),_:2},1032,["to"]))]))),128))])]),t("h1",Te,h(l.titleCase(o.tableName))+" - "+h(l.table),1),o.noData?u("",!0):(d(),i("div",qe,[t("div",Le,[Ce,Ae,g(t("input",{type:"text","onUpdate:modelValue":e[0]||(e[0]=s=>o.searchTerm=s),id:"table-search-users",class:"block p-2 pl-10 text-sm text-pickled-900 border border-pickled-300 rounded-lg w-40 md:w-70 lg:w-80 bg-pickled-50 focus:ring-rock-blue-500 focus:border-rock-blue-500 dark:bg-pickled-700 dark:border-pickled-600 dark:placeholder-pickled-400 dark:text-white dark:focus:ring-rock-blue-500 dark:focus:border-rock-blue-500",placeholder:"Search for records"},null,512),[[z,o.searchTerm]]),t("button",{onClick:e[1]||(e[1]=(...s)=>l.toggleAction&&l.toggleAction(...s)),id:"dropdownActionButton",class:"w-30 inline-flex items-centerblock py-2 px-2 ml-2 text-sm text-pickled-900 dark:text-pickled-200 border border-pickled-300 rounded-lg bg-pickled-50 focus:ring-rock-blue-500 focus:border-rock-blue-500 dark:bg-pickled-700 dark:border-pickled-600 dark:focus:ring-rock-blue-500 dark:focus:border-rock-blue-500",type:"button",onKeyup:e[2]||(e[2]=L(s=>o.toggleActions=!1,["esc"]))},[Me,k(" Action "),Ze],32),o.toggleActions?(d(),i("div",De,[t("ul",Be,[Ne,t("li",Se,[je,(d(),i("svg",{onClick:e[3]||(e[3]=s=>r.copyToClipboard(l.table.id)),"aria-hidden":"true",class:"w-4 my-1 h-4 text-pickled-500",fill:"none",viewBox:"0 0 32 32",xmlns:"http://www.w3.org/2000/svg",width:"24",height:"24",stroke:"currentColor","stroke-width":"2","stroke-linecap":"round","stroke-linejoin":"round"},Pe))])])])):u("",!0),t("button",{onClick:e[4]||(e[4]=(...s)=>l.toggleColumn&&l.toggleColumn(...s)),class:"ml-2 inline-flex items-centerblock py-2 px-2 text-sm text-pickled-900 dark:text-pickled-200 border border-pickled-300 rounded-lg bg-pickled-50 focus:ring-rock-blue-500 focus:border-rock-blue-500 dark:bg-pickled-700 dark:border-pickled-600 dark:focus:ring-rock-blue-500 dark:focus:border-rock-blue-500",type:"button",onKeyup:e[5]||(e[5]=L(s=>o.toggleColumns=!1,["esc"]))},[Ue,k(" Columns "),Ee],32),o.toggleColumns?(d(),i("div",Fe,[t("ul",He,[t("li",Ie,[k(" Select All "),t("input",{ref:"selectAll",type:"checkbox",onChange:e[6]||(e[6]=(...s)=>l.selectAllColumns&&l.selectAllColumns(...s)),class:"form-checkbox h-5 w-5 text-pickled-600"},null,544)]),Oe,C(c,{modelValue:o.columns,"onUpdate:modelValue":e[8]||(e[8]=s=>o.columns=s),onStart:e[9]||(e[9]=s=>r.drag=!0),onEnd:e[10]||(e[10]=s=>r.drag=!1),"item-key":"id",handle:".handle","ghost-class":"ghost"},{item:m(({element:s})=>[t("li",Re,[Ke,t("a",We,h(s.name),1),g(t("input",{"onUpdate:modelValue":b=>s.checked=b,onChange:e[7]||(e[7]=(...b)=>l.uncheckSelectAllButton&&l.uncheckSelectAllButton(...b)),type:"checkbox",class:"form-checkbox h-5 w-5 text-pickled-600",checked:""},null,40,Je),[[w,s.checked]])])]),_:1},8,["modelValue"])])])):u("",!0)]),t("div",Qe,[t("label",Ye,[g(t("input",{type:"checkbox",value:"",class:"sr-only peer","onUpdate:modelValue":e[11]||(e[11]=s=>o.showDeleted=s),onClick:e[12]||(e[12]=(...s)=>l.toggleDeleted&&l.toggleDeleted(...s))},null,512),[[w,o.showDeleted]]),Ge,Xe])]),t("div",$e,[t("label",et,[g(t("input",{type:"checkbox",value:"",class:"sr-only peer","onUpdate:modelValue":e[13]||(e[13]=s=>o.showArchived=s),onClick:e[14]||(e[14]=(...s)=>l.toggleArchioved&&l.toggleArchioved(...s))},null,512),[[w,o.showArchived]]),tt,rt])])])),o.toggleColumns?(d(),i("div",lt,[t("ul",st,[t("li",ot,[k(" Select All "),t("input",{ref:"selectAll",type:"checkbox",onChange:e[15]||(e[15]=(...s)=>l.selectAllColumns&&l.selectAllColumns(...s)),class:"form-checkbox h-5 w-5 text-pickled-600"},null,544)]),dt,C(c,{modelValue:o.columns,"onUpdate:modelValue":e[17]||(e[17]=s=>o.columns=s),onStart:e[18]||(e[18]=s=>r.drag=!0),onEnd:e[19]||(e[19]=s=>r.drag=!1),"item-key":"id",handle:".handle","ghost-class":"ghost"},{item:m(({element:s})=>[t("li",it,[at,t("a",ct,h(s.name),1),g(t("input",{"onUpdate:modelValue":b=>s.checked=b,onChange:e[16]||(e[16]=(...b)=>l.uncheckSelectAllButton&&l.uncheckSelectAllButton(...b)),type:"checkbox",class:"form-checkbox h-5 w-5 text-pickled-600",checked:""},null,40,nt),[[w,s.checked]])])]),_:1},8,["modelValue"])])])):u("",!0),o.toggleActions?(d(),i("div",ht,[t("ul",ut,[kt,t("li",bt,[pt,(d(),i("svg",{onClick:e[20]||(e[20]=s=>r.copyToClipboard(l.table.id)),"aria-hidden":"true",class:"w-4 my-1 h-4 text-pickled-500",fill:"none",viewBox:"0 0 32 32",xmlns:"http://www.w3.org/2000/svg",width:"24",height:"24",stroke:"currentColor","stroke-width":"2","stroke-linecap":"round","stroke-linejoin":"round"},mt))])])])):u("",!0),(d(),T(y,{key:o.key,table_id:l.table,class:"pl-0 overflow-auto h-auto w-full",schema:l.requestSchema,encoded:o.showDeleted&&o.showArchived&&o.tableName!==""?l.encodedForALL:o.showDeleted&&!o.showArchived&&o.tableName!==""?l.encodedToHideArchived:!o.showDeleted&&o.showArchived&&o.tableName!==""?l.encodedToHideDeleted:!o.showDeleted&&!o.showArchived&&o.tableName!==""?l.encodedForNone:"",script:o.script,columns:l.processedColumns,search:o.searchTerm},null,8,["table_id","schema","encoded","script","columns","search"])),t("div",wt,[t("button",{onClick:e[21]||(e[21]=s=>l.goToTable(l.table)),disabled:o.isBaseTable,class:M(["bg-rock-blue-600 hover:bg-rock-blue-700 text-white font-bold py-2 px-4 rounded",{"opacity-50 cursor-not-allowed disabled":o.isBaseTable}])}," Create ",10,vt),o.isBaseTable?(d(),i("div",xt," Note: Use the base api to create data for "+h(l.table)+". ",1)):u("",!0)])])}const qt=A(me,[["render",yt]]);export{qt as default};