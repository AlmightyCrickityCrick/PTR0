defmodule SpotifyStrategy do
  use OAuth2.Strategy
  def client do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: "fc267a4808c74f1d88c9a0cc80946c68",
      redirect_uri: "http://127.0.0.1:8080/callback",
      site: "https://api.spotify.com/v1",
      authorize_url: "https://accounts.spotify.com/authorize",
      token_url: "https://accounts.spotify.com/api/token",
      token_method: :post
    ])
  end

  def tokenClient do
    OAuth2.Client.new([
      redirect_uri: "http://127.0.0.1:8080/callback",
      client_id: "fc267a4808c74f1d88c9a0cc80946c68",
      client_secret: "baf5d1275cff437dad27d540f1c7957a",
      site: "https://api.spotify.com/v1",
      token_url: "https://accounts.spotify.com/api/token",
      token_method: :post
    ])
  end

  def authorize_url!(params \\ []) do
    client()
    |> put_param(:scope, "ugc-image-upload playlist-read-private playlist-modify-private user-read-private user-read-email")
    |> put_param(:response_type, :code)
    |> put_param(:state, "1234")
    |> OAuth2.Client.authorize_url!(params)
  end

  def acquire_token() do
    client = get_token!()
    {:ok, token_set} = Poison.decode(client.token.access_token)
    IO.inspect(token_set)
    :ets.insert(:spotify, {:access_token, Map.get(token_set, "access_token")})
    :ets.insert(:spotify, {:refresh_token, Map.get(token_set, "refresh_token")})

  end
  # you can pass options to the underlying http library via `options` parameter
  defp get_token!(params \\ [], headers \\ [], options \\ []) do
    {_, code} = List.first(:ets.lookup(:spotify, :code))
    tokenClient()
    |> put_param(:grant_type, :authorization_code)
    |> put_param(:code, code )
    |> put_param(:redirect_uri, "http://127.0.0.1:8080/callback")
    # |> put_header("Authorization", "Basic #{Base.encode64("fc267a4808c74f1d88c9a0cc80946c68:baf5d1275cff437dad27d540f1c7957a")}") This shit doesnt work
    |> put_header("Content-Type", "application/x-www-form-urlencoded")
    |> OAuth2.Client.get_token!(params,headers, options)
  end

  def refreshClient() do
    OAuth2.Client.new([
      strategy: OAuth2.Strategy.Refresh,
      redirect_uri: "http://127.0.0.1:8080/callback",
      client_id: "fc267a4808c74f1d88c9a0cc80946c68",
      client_secret: "baf5d1275cff437dad27d540f1c7957a",
      site: "https://api.spotify.com/v1",
      token_url: "https://accounts.spotify.com/api/token",
      token_method: :post
    ])
  end

  def get_me() do
    {_, token} = List.first(:ets.lookup(:spotify, :access_token))
    client()
    |> put_param(:token, token)
    |> put_header("Authorization", "Bearer #{token}")
    |> put_header("Content-Type", "application/json")
    |> OAuth2.Client.get!("/me")
  end

  def refresh_token() do
    client = refresh_token!()
    {:ok, token_set} = Poison.decode(client.token.access_token)
    IO.inspect(token_set)
    :ets.insert(:spotify, {:access_token, Map.get(token_set, "access_token")})

  end

  defp refresh_token!(params \\ [], headers \\ [], options \\ []) do
   {_, token} = List.first(:ets.lookup(:spotify, :refresh_token))
    refreshClient()
    |> put_param(:grant_type, :refresh_token)
    |> put_param(:refresh_token, token)
    |> put_header("Content-Type", "application/x-www-form-urlencoded")
    |> OAuth2.Client.get_token!(params, headers, options)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end

  def create_playlist(name) do
    tmp = %{:name => name, :description => name, :public => false}
    {:ok, body} = Poison.encode(tmp)
    {_, id} = List.first(:ets.lookup(:spotify, :id))
    refresh_token()
    {_, token} = List.first(:ets.lookup(:spotify, :access_token))
    client()
    |> put_param(:token, token)
    |> put_header("Authorization", "Bearer #{token}")
    |> put_header("Content-Type", "application/json")
    |> OAuth2.Client.post!("/users/#{id}/playlists", body, [], [])
  end

  def add_song(pl_id, song_id) do
    tmp = %{"uris" => [
      "spotify:track:#{song_id}"
    ],}
    {:ok, body} = Poison.encode(tmp)
    refresh_token()
    {_, token} = List.first(:ets.lookup(:spotify, :access_token))
    client()
    |> put_param(:token, token)
    |> put_header("Authorization", "Bearer #{token}")
    |> put_header("Content-Type", "application/json")
    |>OAuth2.Client.post!("/playlists/#{pl_id}/tracks", body, [], [])
  end

  def add_image(pl_id, image) do
    # tmp = %{"uris" => [
    #   "spotify:track:#{song_id}"
    # ],}
    # {:ok, body} = Poison.encode(tmp)
    refresh_token()
    {_, token} = List.first(:ets.lookup(:spotify, :access_token))
    client()
    |> put_param(:token, token)
    |> put_header("Authorization", "Bearer #{token}")
    |> put_header("Content-Type", "image/jpeg")
    |>OAuth2.Client.put!("/playlists/#{pl_id}/images", image, [], [])
  end

end
