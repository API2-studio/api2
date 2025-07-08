{application,hammer_plug,
             [{applications,[kernel,stdlib,elixir,plug,hammer]},
              {description,"A plug to apply rate-limiting, using Hammer."},
              {modules,['Elixir.Hammer.Plug','Elixir.Hammer.Plug.NilError',
                        'Elixir.Hammer.Plug.NoRateLimitError']},
              {registered,[]},
              {vsn,"2.1.1"}]}.
