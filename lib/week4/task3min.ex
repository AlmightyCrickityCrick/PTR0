defmodule Task3Min do

  #Creates tasks that print Strings and attaches a monitor to them. Sends back to caller process their ID's so they would be
  #individually adressable
  def pool_init(nr, process) do
    actorlist = for _ <- 1..nr do
      {pid, _} = spawn_monitor(Task3Min, :echo_worker, [])
      pid
    end
    send(process, {:pids, actorlist})
    supervisor_loop(actorlist)
  end

  #Supervisor loops that checks whether a task is down
  def supervisor_loop(actorList) do
    receive do
      {:get_list, pid} ->
        send(pid, {:pids, actorList})
      {:DOWN, _, :process, pid , :kill} ->
          IO.puts("#{inspect(pid)} down")
          {pd, _} = spawn_monitor(Task3Min, :echo_worker, [])
          clean_list = List.delete(actorList, pid)
          new_list = List.insert_at(clean_list, -1, pd)
          supervisor_loop(new_list)
    end
    supervisor_loop(actorList)
  end

  #Work that prints what they are told, or die if :kill is invoked
  def echo_worker do
    receive do
      :kill ->
        IO.puts(:kill)
        exit(:kill)
      msg ->
        IO.puts("echo #{msg}")
    end
    echo_worker()
  end
end
