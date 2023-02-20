defmodule Task3Bonus1 do

  #Initiates the supervisor
  def init_senzors() do
    init_main_supervisor()
  end

  #Creates each senzor and supervisor for main and assigns them a key
  def init_main_supervisor() do
    {cabin, _ }= spawn_monitor(Task3Bonus1, :init_sensor, ["cabin"])
    {motor, _ } = spawn_monitor(Task3Bonus1, :init_sensor, ["motor"])
    {chasis, _ } = spawn_monitor(Task3Bonus1, :init_sensor, ["chasis"])
    {wheel, _ } =  spawn_monitor(Task3Bonus1, :init_wheel_supervisor, [self()])


    main_supervisor_loop(%{:cabin => cabin, :motor => motor, :chasis => chasis, :wheel_sup => wheel },0)


  end

    #Creates each senzor and supervisor for wheel and assigns them a key
  def init_wheel_supervisor(main_pid) do
    {wheel1, _ }= spawn_monitor(Task3Bonus1, :init_sensor, ["wheel1"])
    {wheel2, _ }= spawn_monitor(Task3Bonus1, :init_sensor, ["wheel2"])
    {wheel3, _ }= spawn_monitor(Task3Bonus1, :init_sensor, ["wheel3"])
    {wheel4, _ }= spawn_monitor(Task3Bonus1, :init_sensor, ["wheel4"])
    wheel_supervisor_loop(%{:wheel1 => wheel1, :wheel2 => wheel2, :wheel3 => wheel3, :wheel4 => wheel4 }, main_pid)
  end

  #Main supervisor. Awaits any crash reports from other subordinates. If 4 crashes reported kills veryone and itself

  def main_supervisor_loop(sensors, crashes_recorded) do
    receive do
      {:DOWN, _, :process, pid , :kill} ->
        {key, _} = Enum.find(sensors, fn {_, val} -> val == pid end)
        {val, _ }= spawn_monitor(Task3Bonus1, :init_sensor, [key])
        {_, clean_map} = Map.pop(sensors, key)
        new_list = Map.put(clean_map, key, val)
        main_supervisor_loop(new_list, crashes_recorded + 1)
      :crash_report ->
        if (crashes_recorded >= 3) do
          IO.puts("-----------------DEPLOYING AIRBAGS AND STOPPING EVERYTHING ---------------------")
          send(Map.get(sensors, :wheel_sup), :shutdown)
          for {k, v} <- sensors do
            if(k != :wheel_sup) do Process.exit(v, :kill) end
          end
          exit(:shutdown)
        end
        main_supervisor_loop(sensors, crashes_recorded + 1)
    end

    main_supervisor_loop(sensors, crashes_recorded)

  end

    #Wheel supervisor. Awaits any crash reports from wheels. Reports to Main

  def wheel_supervisor_loop(sensors, main_pid) do
    receive do
      {:DOWN, _, :process, pid , :kill} ->
        {wheel_nr, _} = Enum.find(sensors, fn {_, val} -> val == pid end)
        IO.inspect(wheel_nr)
        {wheel1, _ }= spawn_monitor(Task3Bonus1, :init_sensor, [wheel_nr])
        {_, clean_map} = Map.pop(sensors, wheel_nr)
        new_list = Map.put(clean_map, wheel_nr, wheel1)
        send(main_pid, :crash_report)
        wheel_supervisor_loop(new_list, main_pid)
        :shutdown ->
          for {_, v} <- sensors do
            Process.exit(v, :kill)
          end
          exit(:shutdown)
    end
    wheel_supervisor_loop(sensors, main_pid)
  end

  #Function of senzors. Just picks a number from 1 to 6, if its 5, crashes
  def init_sensor(component) do
    import :timer
    IO.puts("Senzor Testing #{component}")
    x = Enum.random([1, 2, 3, 4, 5, 6])
    sleep(200)
    if(rem(x, 5) == 0) do
      IO.puts("Senzor issues #{component}")
      exit(:kill)
    end
    init_sensor(component)
  end


end
