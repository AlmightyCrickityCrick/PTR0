defmodule Task2 do
  def printingTask(data) do
    IO.puts(data)
    0
  end

  def listenTask() do
    receive do
      {:ok, value, caller} ->
        if(is_bitstring(value)) do send(caller, {:result, String.downcase(value)})
        else if (is_number(value)) do send(caller, {:result, value + 1})
        else send(caller, {:result,"Cant handle this"})
        end
    end
    end
    listenTask()
  end

  def suicidalTask() do
    import :timer
    sleep(500)
    exit(:death)
  end

  def monitoringTask() do
    #Spawns a monitored process
    res = spawn_monitor(Task2, :suicidalTask, [])
    IO.inspect(res)
    receive do
      message -> IO.puts("Message received: #{inspect(message)}")
      after 1000 -> IO.puts("Business as usual")
    end
  end

  def averager(value) do
    receive do
      #If a message with new number is received, average is calculated
      #and the function is recursively called with new average as argument
      msg ->
        if (is_number(msg)) do
          new_value = (value + msg) /2
          IO.puts("Current Average: #{new_value}")
          averager(new_value)
        end
    end
    #If no message then loop with previous value continues
    averager(value)
    end

    #Queue stuff

    def new_queue() do
      pid = spawn(Task2, :queueListener, [[]])
      pid
    end

    def push(pid, value) do
      send(pid, {:push, value})
      :ok
    end

    def pop(pid) do
      send(pid, {:pop, self()})
      receive do
        msg ->
          msg
      end
    end

    def queueListener(elementList) do
      receive do
        {:push, value} ->
          newList = List.insert_at(elementList, -1, value)
          queueListener(newList)
        {:pop, caller} ->
          val = List.first(elementList)
          newList = List.delete_at(elementList, 0)
          send(caller, val)
          queueListener(newList)
      end
      queueListener(elementList)
    end

    def semaphorMain(pid) do
      import :timer
      #sleep(Enum.random([1000, 2000, 3000, 4000, 5000]))
      IO.puts("#{inspect(self())} is trying to acquire Mutex")
      Task2Semaphore.acquire(pid)
      IO.puts("#{inspect(self())} is acquired Mutex")
      sleep(3000)
      Task2Semaphore.release(pid)
      IO.puts("#{inspect(self())} released Mutex")
    end

  end
