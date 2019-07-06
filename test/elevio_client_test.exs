defmodule Elevio.ClientTest do
  use ExUnit.Case, async: true
  @moduletag :elevio

  describe "Elevio client instance" do
    test "Elevio client default configuration" do
      client = Elevio.Client.new!()
      assert client.__struct__ == Elevio.Client
    end

    test "Elevio client manual configuration (empty url)" do
      assert_raise(
        ArgumentError,
        fn -> Elevio.Client.new!(" ", "api-key", "token") end
      )
    end

    test "Elevio client manual configuration" do
      url = "https://localhost"
      api = "my-api-key"
      token = "my-jwt-token"
      client = Elevio.Client.new!(url, api, token)
      assert url == client.base_url
      assert api == client.api_key
      assert token == client.token
    end
  end

  describe "Elevio client capture HTTP request" do
    setup do
      bypass = Bypass.open()
      client = Elevio.Client.new!(endpoint_url(bypass.port), "api_key", "token")
      {:ok, bypass: bypass, client: client}
    end

    test "HTTP request", %{bypass: bypass, client: client} do
      ep = "/v1/articles"

      Bypass.expect_once(bypass, "GET", ep, fn conn ->
        Plug.Conn.resp(
          conn,
          200,
          ~s<{"articles": []}>
        )
      end)

      {:ok, m} = Elevio.Client.get(client, ep)
      request = m.request

      url = request.url
      assert url == "#{endpoint_url(bypass.port)}#{ep}"

      headers = request.headers
      assert Keyword.get(headers, :"x-api-key") == client.api_key
      assert Keyword.get(headers, :Authorization) == "Bearer #{client.token}"
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
