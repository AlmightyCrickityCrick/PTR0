defmodule Task2Test do
  use ExUnit.Case
  doctest Task2

  #@tag mustexec: true
  test "min 1 test" do
    #Spawns an actor that receives a message and prints it
    pid = spawn(Task2, :printingTask, ["Why are we here? Just to suffer?"])
    IO.inspect(pid)
  end

  #@tag mustexec: true
  test "min 2 test with spawn" do
    #Spawns the actors and assigns to it the recursive function listenTask
    pid = spawn(Task2, :listenTask, [])
    IO.inspect(pid)
    #Saves the adress of the current process
    caller = self()
    #Send the messages to the actor along with the "adress to which to send the reply"
    send(pid,{:ok, 10, caller})
    send(pid,{:ok, "Heloo", caller})
    send(pid, {:ok, {13, "Macarena"}, caller})

    #Quick function to listen to any incoming messages
    res = fn -> receive do
      {:result, value} -> value
    end
    end
    #Retrieves the 3 messages from the function and displays them
      results = Enum.map(1 .. 3, fn _ -> res.() end)
      IO.inspect(results)
      assert results == [11, "heloo", "Cant handle this"]
    end

  #@tag mustexec: true
    test "min 3 test" do
      import :timer
      #Spawns an actor that spawns another monitored actor and cheks if the child actor doesnt die
      _pid = spawn(Task2, :monitoringTask, [])
      #This is here so the test doesn't cancel before the process commits seppuku
      sleep(700)
    end

  #@tag mustexec: true
    test "min 4 test" do
      #Spawns an actor for a function that takes numbers as arguments
      pid = spawn(Task2, :averager, [0])
      IO.inspect(pid)
      send(pid, 10)
      send(pid, 10)
      send(pid, 10)
    end

  #@tag mustexec: true
    test "main 1 test" do
      pid = Task2.new_queue()
      IO.puts(Task2.push(pid, 42))
      v = Task2.pop(pid)
      IO.puts(v)
      assert v == 42
    end

   #@tag mustexec: true
    test "main 2 test" do
      import :timer
      pid = Task2Semaphore.createSemaphore()
      spawn(Task2, :semaphorMain, [pid])
      spawn(Task2, :semaphorMain, [pid])
      spawn(Task2, :semaphorMain, [pid])
      sleep(10000)
    end

    #@tag mustexec: true
    test "bonus 1 test" do
      nd = Task2scheduler.create_scheduler()
      send(nd, :create)
      send(nd, :create)
      send(nd, :create)
      send(nd, :create)
      import :timer
      sleep(10000)
    end

    #@tag mustexec: true
    test "bonus 2 test" do
      dll = Task2dll.create_dll([3, 4, 5, 42])
      IO.inspect(dll)
      IO.inspect(Task2dll.traverse(dll))
      IO.inspect(Task2dll.inverse(dll))
    end
end
