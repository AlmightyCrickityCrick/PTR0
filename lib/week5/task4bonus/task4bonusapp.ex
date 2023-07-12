defmodule Task4BonusApp do
  use Application
  require Logger

  def start(_type, _args) do
    IO.puts(SpotifyStrategy.authorize_url!())
    :ets.new(:spotify, [:named_table, :set, :public])

    children =[{Plug.Cowboy, scheme: :http, plug: Task4BonusServer, options: [port: 8080] }]
    Supervisor.start_link(children, strategy: :one_for_one)

  end




end
