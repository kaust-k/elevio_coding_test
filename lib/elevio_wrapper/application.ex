defmodule ElevioWrapper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    # This will throw error if env vars are not set properly and application won't start!
    _ = Elevio.Client.new!()

    Logger.info("Starting application...")
    Logger.info("Listening on port #{http_port()}")

    Supervisor.start_link(children(), opts())
  end

  # List all child processes to be supervised
  defp children do
    [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: ElevioWrapper.Endpoint,
        options: [port: http_port()]
      )
    ]
  end

  defp opts do
    [strategy: :one_for_one, name: ElevioWrapper.Supervisor]
  end

  defp http_port do
    Application.get_env(:elevio_wrapper, :http)[:port]
  end
end
