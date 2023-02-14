defmodule Task2scheduler do

  def create_scheduler do
    IO.inspect(self())
    pid = spawn(Task2scheduler, :scheduler, [])
    pid
  end

  def scheduler() do
    receive do
      {:DOWN, _, :process, _ , :normal} ->
        IO.puts("Task successful")
      :create->
        _task_pid = spawn_monitor(Task2scheduler, :riskyBusiness, [])
      {:DOWN, _, :process, _ , :kill} ->
        IO.puts("Task Failed")
        send(self(), :create)
        msg -> IO.puts("#{inspect(msg)}")
    end
    scheduler()
  end


  def riskyBusiness() do
    chance = Enum.random([0, 1])
    if(chance == 1) do exit(:kill)
    else exit(:normal)
    end
  end

end
