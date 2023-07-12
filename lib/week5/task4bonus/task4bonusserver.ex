defmodule Task4BonusServer do
  use Plug.Router
  require Logger

  plug Plug.Parsers, parsers: [:json], pass: ["text/*"], json_decoder: Poison
  plug :match
  plug :dispatch

  get "/"  do
    send_resp(conn, 200, "")
  end

  get "/callback" do
    code = Map.get(conn.params, "code")
    IO.inspect(code)
    :ets.insert(:spotify, {:code, code})

    SpotifyStrategy.acquire_token()


    me = SpotifyStrategy.get_me().body

    IO.inspect(me)

    {:ok, me_info} = Poison.decode(me)
    :ets.insert(:spotify, {:id, Map.get(me_info, "id")})
    IO.inspect(:ets.lookup(:spotify, :id))

    SpotifyStrategy.refresh_token()
    send_resp(conn, 200, "" )
  end

  get "playlist/:name" do
    res = SpotifyStrategy.create_playlist(name).body
    {:ok, pl_info} = Poison.decode(res)
    IO.inspect(res)
    playlist = Map.get(pl_info, "id")

    IO.inspect(SpotifyStrategy.add_song(playlist, "1dfsPqH09vnzUWEOsN98Ex"))
    IO.inspect(SpotifyStrategy.add_song(playlist,"1i0NAz5emJMbRWSkADMsL7"))

    {:ok, tmp} = File.read("tuna.jpg")
    image =  Base.encode64(tmp)
    IO.inspect(SpotifyStrategy.add_image(playlist, image))


    send_resp(conn, 200, res)
  end



  match _ do
    Logger.info("not correct URL given?")
    send_resp(conn, 400, "")
  end


end
