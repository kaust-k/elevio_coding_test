defmodule Elevio.Articles do
  @moduledoc """
  This module contains functions to interact with Elevio Article APIs.
  """

  alias Elevio.Client

  @typedoc """
  An atom (:ok or :error) followed by parsed HTTP response
  """
  @type response :: {atom, map}

  defmodule ListAllParams do
    @type t :: %__MODULE__{page_number: integer, page_size: integer}
    defstruct page_number: 1, page_size: 100
  end

  @doc """
  Lists all documents

  `ListAllParams` can be used to modify pagination support.
  """
  @spec list_all(Client.t(), ListAllParams.t()) :: response
  def list_all(%Client{} = client, %ListAllParams{} = params \\ %ListAllParams{}) do
    Client.get(client, "/v1/articles", params: Map.from_struct(params))
    |> handle_response
  end

  @doc """
  Get a document using id
  """
  @spec get(Client.t(), integer) :: response
  def get(%Client{} = client, id \\ 1) do
    Client.get(client, "/v1/articles/#{id}")
    |> handle_response
  end

  defmodule SearchParams do
    @type t :: %__MODULE__{query: String.t()}
    defstruct [:query]
  end

  @doc """
  Search for articles
  """
  @spec search(Client.t(), String.t(), SearchParams.t()) :: response
  def search(%Client{} = client, lang_code, %SearchParams{} = params \\ %SearchParams{}) do
    Client.get(client, "/v1/search/#{String.trim(lang_code)}", params: Map.from_struct(params))
    |> handle_response
  end

  defp handle_response(res) do
    case res do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Poison.decode(body) do
          {:ok, decoded} -> {:ok, decoded}
          {:error, error} -> {:error, error}
        end

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        case Poison.decode(body) do
          {:ok, decoded} -> {:ok, %{status_code: status_code, message: decoded}}
          {:error, error} -> {:error, %{status_code: status_code, message: error}}
        end

      {:error, %HTTPoison.Error{} = error} ->
        {:error,
         %{error: %{message: "Something went wrong", reason: Map.get(error, :reason, "Unknown")}}}
    end
  end
end
