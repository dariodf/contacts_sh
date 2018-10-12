# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :contacts_sh,
  ecto_repos: [ContactsSh.Repo]

# Configures the endpoint
config :contacts_sh, ContactsShWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LH3k0ct5n88GQ33QoJ72zRJSxswe35WAUCQGfX4c5lhRthmrLh1Y1I5vwJw4pV1m",
  render_errors: [view: ContactsShWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ContactsSh.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :contacts_sh, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: ContactsShWeb.Router,
      endpoint: ContactsShWeb.Endpoint
    ]
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
