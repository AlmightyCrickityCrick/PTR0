defmodule Task4App do
  use Application
  require Logger

  def start(_type, _args) do
    children =[{Plug.Cowboy, scheme: :http, plug: MarvelRouter, options: [port: 8080] }]
    MarvelStore.create()


    Logger.info("App started...")

    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
