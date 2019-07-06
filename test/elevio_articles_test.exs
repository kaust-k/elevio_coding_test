defmodule Elevio.ArticlesTest do
  use ExUnit.Case, async: true
  @moduletag :elevio

  describe "Elevio Articles" do
    @list_documents_fields ~w(articles page_number page_size total_entries total_pages)

    setup do
      {:ok, client: Elevio.Client.new!()}
    end

    test "List documents", %{client: client} do
      {ok?, %{} = m} = Elevio.Articles.list_all(client)
      assert ok? == :ok
      assert @list_documents_fields |> Enum.all?(&Map.has_key?(m, &1))
    end

    test "Get document", %{client: client} do
      {ok?, %{} = m} = Elevio.Articles.get(client)
      assert ok? == :ok
      assert Map.has_key?(m, "article")
    end
  end

  describe "Elevio Articles wrong config" do
    test "invalid url" do
      client = Elevio.Client.new!("http", "api_key", "token")
      {ok?, %{}} = Elevio.Articles.get(client)
      assert ok? == :error
    end
  end

  describe "Elevio Articles bypass" do
    setup do
      bypass = Bypass.open()
      client = Elevio.Client.new!(endpoint_url(bypass.port), "api_key", "token")
      {:ok, bypass: bypass, client: client}
    end

    test "unreachable server", %{bypass: bypass, client: client} do
      Bypass.down(bypass)
      {status, _} = Elevio.Articles.list_all(client)
      Bypass.up(bypass)
      assert status == :error
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
