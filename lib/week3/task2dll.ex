defmodule Task2dll do
  def create_dll(list) do
    first = create_dll(self(), list)
    #Performs a cascade correction of all actor parent ids
    send(first, {:update_parent, self()})
    first
  end


defp create_dll(_me, []) do nil end

defp create_dll(head, [me|tail]) do
  #This does not work quite well because it's sending the value of the current node as future parentid, not the actor adress
    pid = spawn(Task2dll, :spawn_element, [head, me, create_dll(me, tail)])
    pid
  end

  def spawn_element(parentid, value, childid) do
    receive do
      {:update_parent, val} ->
        if (childid != nil) do send(childid, {:update_parent, self()}) end
        spawn_element(val, value, childid)
      {:traverse_request} ->
        if(childid != nil) do
          send(childid, {:traverse_request})
        else send(parentid, {:traverse_response, [value]})
        end
      {:traverse_response, val} -> send(parentid, {:traverse_response, List.insert_at(val, 0, value)})

      {:inverse_request} ->
        if(childid != nil) do
        send(childid, {:inverse_request})
        else send(parentid, {:inverse_response, [value]})
        end

      {:inverse_response, val} -> send(parentid, {:inverse_response, List.insert_at(val, -1, value)})
    end

    spawn_element(parentid, value, childid)

  end

  def traverse(pid) do
    IO.inspect(self())
    send(pid, {:traverse_request})

    receive do
      {:traverse_response, value} ->
        value
    end

  end

  def inverse(pid) do
    send(pid, {:inverse_request})

    receive do
      {:inverse_response, value} ->
        value
    end
  end
end
