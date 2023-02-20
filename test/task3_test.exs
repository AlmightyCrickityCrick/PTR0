defmodule Task3Test do
  alias Week4.Task3main
  use ExUnit.Case

@tag mustexec: true
  test "minimal" do
    import :timer

    pid = spawn(Task3Min, :pool_init, [5, self()])
    lst = receive do
      {tag, msg} ->
        msg
    end
    IO.inspect(lst)
    send(List.first(lst), :hello)
    send(List.first(lst), :kill)
    sleep(500)

    send(pid, {:get_list, self()})
    lst2 = receive do
      {tag, msg} ->
        msg
    end
    IO.inspect(lst2)
    send(List.first(lst2), :hello)
    send(List.first(lst2), :kill)
  end

  @tag mustexec: true
  test "main" do
    import :timer
    pid = spawn(Task3Main, :init_supervisor, [])
    send(pid, {:clean, 12})
    sleep(500)
    send(pid, {:clean, "Monster noises"})
    sleep(500)
  end

  @tag mustexec: true
  test "bonus1" do
    import :timer
    pid = spawn(Task3Bonus1, :init_senzors, [])
    sleep(10000)
  end

  @tag mustexec: true
  test "bonus2" do
    import :timer
    pid = spawn(Task3Bonus2, :init_interogation, [])
    send(pid, "What does Marsellus Wallace look like?")
    sleep(100)
    send(pid, "What country you from?")
    sleep(100)
    send(pid, "They speak english in what?")
    sleep(100)
    send(pid, "English motherfucker do you speak it?")
    sleep(100)
    send(pid, "Say what again!")
    sleep(100)
    send(pid, "Say what again, I dare you!")
  end
end
