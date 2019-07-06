use Mix.Config

config :elevio_wrapper, Elevio,
  base_url: System.get_env("ELEVIO_BASE_URL"),
  api_key: System.get_env("ELEVIO_API_KEY"),
  token: System.get_env("ELEVIO_TOKEN")

config :elevio_wrapper, :http,
  port: String.to_integer(System.get_env("PORT") || "4000")
