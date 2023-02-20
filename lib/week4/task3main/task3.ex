defmodule Task3Main do
  #Starts the supervisor loop and assigns the lines of workers
  def init_supervisor() do
  supervisor_loop(createLine())
  end

  #Creates the line by calling createWorker with a specific id which is their place in the line
  def createLine()do
    actorlist = for i <- 1..4 do
      {pid, _} = createLineWorker(i)
      pid
      end
      IO.inspect(actorlist)
    actorlist
    end

    #First worker that splits strings based on ' '. Main point of failure for the line, so sends an exit if error when trying to split
    def splitter(sup) do
      receive do
        :shutdown ->
          IO.puts("Shutting down")
          exit(:shutdown)
        {:split, value} ->
          try do
            send(sup, {:split_result, String.split(value, " ")})
          rescue
            _ -> exit(:kill)
          end
      end
      splitter(sup)
    end


    #Iterates through graphemes and changes m and n or returns the current letter
    def swap_letters(value) do
      res = for x <- value do
      current = String.downcase(x)
      letters = String.graphemes(current)
          for y <-letters do
            case y do
              "m" -> "n"
              "n" -> "m"
              _ -> y
            end
          end
        end
      res
    end

    #Second worker, swaps leters and downcases each word.
    def swapper(sup) do
      receive do
        :shutdown ->
          IO.puts("Shutting down")
          exit(:shutdown)
        {:swap, value} ->
          send(sup, {:swap_result , swap_letters(value)})
      end
      swapper(sup)
    end


    #Third worker, joins the Strings in list with " "
    def joiner(sup) do
      receive do
        :shutdown ->
          IO.puts("Shutting down")
          exit(:shutdown)
        {:join, value} ->
          send(sup, {:join_result, Enum.join(value, " ")})
      end
      joiner(sup)
    end

    #Last worker, prints result
    def printer(sup) do
      receive do
        :shutdown ->
          IO.puts("Shutting down")
          exit(:shutdown)
         {:print, value} ->
          IO.puts(value)
      end
      printer(sup)
    end

    #Function to create line worker based on their id
  def createLineWorker(i) do
    case i do
      1 -> spawn_monitor(Task3Main, :splitter, [self()])
      2 -> spawn_monitor(Task3Main, :swapper, [self()])
      3 -> spawn_monitor(Task3Main, :joiner, [self()])
      4 -> spawn_monitor(Task3Main, :printer, [self()])
    end
  end

  #Supervisor loop that receives result from each worker and sends it to the next
  def supervisor_loop(actorlist) do
    receive do
      {:clean, value} ->
        send(List.first(actorlist), {:split, value})
      {:split_result, value} ->
        send(Enum.at(actorlist, 1), {:swap, value})

      {:swap_result, value} ->
        send(Enum.at(actorlist, 2), {:join, value})

      {:join_result, value} ->
        send(Enum.at(actorlist, 3), {:print, value})
      {:DOWN, _, :process, _ , :kill} ->
        for x <-  actorlist do
          if(Process.alive?(x)) do send(x, :shutdown) end
        end
        IO.puts("Actors aborted")
        supervisor_loop(createLine())
    end

    supervisor_loop(actorlist)

  end


end
