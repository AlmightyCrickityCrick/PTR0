defmodule MarvelRouter do
  use Plug.Router
  require Logger

  plug Plug.Parsers, parsers: [:json], pass: ["text/*"], json_decoder: Poison
  plug :match
  plug :dispatch


  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  get "/movies" do
    {:ok, res} = Poison.encode(MarvelStore.get_all())
    IO.inspect(res)
    send_resp(conn, 200, res )
  end

  get "/movies/:id" do
    {:ok, res} = Poison.encode(MarvelStore.get(id))
    IO.inspect(res)
    send_resp(conn, 200, res )
  end

  post "/movies" do
    res = MarvelStore.post(conn.body_params)
    send_resp(conn, 200, "id:#{res}")
  end

  put "/movies/:id" do
    res = MarvelStore.put(conn.body_params)
    if(res == :ok ) do send_resp(conn, 200, "Modified") else send_resp(conn, 400, "Bad request") end
  end

  patch "/movies/:id" do
    res = MarvelStore.patch(id, conn.body_params)
    if(res == :ok ) do send_resp(conn, 200, "Modified") else send_resp(conn, 400, "Bad request") end
  end

  delete "/movies/:id" do
    res = MarvelStore.delete(id)
    send_resp(conn, 200, "Deleted")
  end

  match _ do
    send_resp(conn, 404, "Nope!")
  end

end
