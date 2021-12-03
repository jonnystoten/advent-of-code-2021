import Config

config :logger,
  level: :info

config :tesla, adapter: Tesla.Adapter.Hackney

# Create 'secret.exs' with a cookie value from adventofcode.com like this:

# config :advent_of_code,
#        :session,
#        "[COOKIE_VALUE]"

import_config("secret.exs")
