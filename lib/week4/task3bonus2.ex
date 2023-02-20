defmodule Task3Bonus2 do
  def init_interogation() do
    {interogee, _} = spawn_monitor(Task3Bonus2, :interogee_loop, [self()])
    interogator_loop(interogee, 0)
  end

  def interogator_loop(pid, whats) do
    receive do
      :what ->
        if(whats >=4) do
          Process.exit(pid, :kill)
          IO.puts("BAM")
        end
        interogator_loop(pid, whats + 1)
      :yes ->
        IO.puts(:ok)
      msg ->
        try do
        IO.puts(msg)
        rescue _ -> IO.inspect(msg)
        end
        send(pid, msg)
    end
    interogator_loop(pid, whats)
  end

  def interogee_loop(interogator_pid) do
    receive do
      _msg ->
        x = Enum.random([1, 2, 3, 4, 5, 6])
        if(x == 3) do
          IO.puts(:yes)
          send(interogator_pid, :yes)
        else
          IO.puts(:what)
          send(interogator_pid, :what)
      end
    end
    interogee_loop(interogator_pid)
  end

end
