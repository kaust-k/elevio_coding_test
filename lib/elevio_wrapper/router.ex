defmodule ElevioWrapper.Router do
  @moduledoc false

  use Plug.Router
  alias Elevio.Client
  alias Elevio.Articles

  plug(:match)
  plug(:dispatch)

  get "/articles" do
    conn = Plug.Conn.fetch_query_params(conn)
    params = to_struct(Articles.ListAllParams, conn.query_params)
    client = Client.new!()
    response = Articles.list_all(client, params)
    send_response(conn, response)
  end

  get "/article/:id" do
    client = Client.new!()
    response = Articles.get(client, id)
    send_response(conn, response)
  end

  get "/search/:lang_code" do
    conn = Plug.Conn.fetch_query_params(conn)
    params = to_struct(Articles.SearchParams, conn.query_params)
    client = Client.new!()
    response = Articles.search(client, lang_code, params)
    send_response(conn, response)
  end

  match _ do
    send_resp(conn, 404, "Requested page not found!")
  end

  defp send_response(conn, {_, response}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(response, pretty: true))
  end

  # https://groups.google.com/d/msg/elixir-lang-talk/6geXOLUeIpI/L9einu4EEAAJ
  defp to_struct(kind, attrs) do
    struct = struct(kind)

    Enum.reduce(Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end)
  end
end
