defmodule Elevio.Client do
  @moduledoc """
  A helper module to make HTTP calls to Elevio REST APIs

  Use `new!/0` to initialize client with default configuration.
  Configuration can be provided in `config.exs` or `defaults.toml`

  Use `new!/3` for manual configuration.
  """

  alias __MODULE__

  @base_url "https://api.elev.io"

  @type t :: %__MODULE__{base_url: String.t(), api_key: String.t(), token: String.t()}
  defstruct [:base_url, :api_key, :token]

  @doc """
  Initializes a new Elevio client with default config.
  Raises an ArgumentError if any of required parameters (base_url, api_key and token) are empty.
  """
  @spec new!() :: Client.t() | no_return
  def new!() do
    new!(base_url(), api_key(), token())
  end

  @doc """
  Initializes a new Elevio client with manual config.
  Raises an ArgumentError if any of required parameters (base_url, api_key and token) are empty.

  ## Parameters
    - url: Base URL of Elevio REST API
    - api_key: Elevio API key
    - token: Elevio Token
  """
  @spec new!(String.t(), String.t(), String.t()) :: Client.t() | no_return
  def new!(url \\ @base_url, api_key, token) do
    unless Enum.all?([url, api_key, token], &is_valid?/1) do
      raise ArgumentError, "Elevio client is not properly configured"
    end

    %Client{base_url: url, api_key: api_key, token: token}
  end

  @doc false
  def get(%Client{} = client, url, options \\ []) do
    HTTPoison.get(request_url(client, url), headers(client), options)
  end

  defp headers(%Client{} = client) do
    ["x-api-key": client.api_key, Authorization: "Bearer #{client.token}"]
  end

  defp request_url(%Client{} = client, url) do
    client.base_url <> url
  end

  defp base_url do
    config(:base_url, @base_url)
  end

  defp api_key do
    config(:api_key)
  end

  defp token do
    config(:token)
  end

  defp config(key, default \\ nil) do
    Application.get_env(:elevio_wrapper, Elevio)[key] || default
  end

  defp is_valid?(str) do
    String.valid?(str) && String.length(String.trim(str)) > 0
  end
end
