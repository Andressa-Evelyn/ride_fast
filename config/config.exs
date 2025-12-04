# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ride_fast,
  ecto_repos: [RideFast.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configure the endpoint
config :ride_fast, RideFastWeb.Endpoint,
  url: [host: "0.0.0.0"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: RideFastWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: RideFast.PubSub,
  live_view: [signing_salt: "t3DHFhH0"]

# Configure the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ride_fast, RideFast.Mailer, adapter: Swoosh.Adapters.Local

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

#Autenticação JWT
config :ride_fast, RideFastWeb.Auth.Guardian,
       issuer: "ride_fast",
       secret_key: "PWyaDduBNx2EPSeriyBI8mL5NMfj5qCTewSEv7jTwi8d8BV2La03NND9V4ZrvqUc"


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
