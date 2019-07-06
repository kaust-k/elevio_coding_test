defmodule ElevioWrapper.Endpoint do
  @moduledoc false

  use Plug.Router

  plug(Plug.Logger, log: :debug)

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)

  forward("/elevio", to: ElevioWrapper.Router)

  match _ do
    send_resp(conn, 404, "Requested page not found!")
  end
end
