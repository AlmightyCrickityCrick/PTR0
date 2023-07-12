defmodule MarvelStore do
  def create() do
  :ets.new(:marvel, [:named_table, :set, :public])

  {:ok, body} = File.read("marvel.json")
  {:ok, json} = Poison.decode(body)

  for movie <- json do
    :ets.insert(:marvel, {Map.get(movie, "id"), movie})
  end
  end

  def get_all do
    tmp = :ets.tab2list(:marvel)
    for {_, val} <- tmp do
      val
    end
  end
  def get(id) do
    res = :ets.lookup(:marvel, String.to_integer(id))
    if(length(res) != 0) do
      {_ , value} = List.first(res)
      value
    else
      []
    end
  end

  def post(movie) do
    id = if(Map.has_key?(movie, "id")) do
      Map.get(movie, "id")
    else
      length(:ets.tab2list(:marvel)) + 1
    end

    :ets.insert(:marvel, {id, movie})
    id
  end

  def put(movie) do
    if(Map.has_key?(movie, "id") and Map.has_key?(movie, "title") and Map.has_key?(movie, "release_year") and Map.has_key?(movie, "director")) do
      :ets.insert(:marvel, {Map.get(movie, "id"), movie})
      :ok
    else
      :no
    end
  end

  def delete(id) do
    :ets.delete(:marvel, String.to_integer(id))
  end

  def patch(id, movie) do
    m = get(id)

    res = for {k, v} <- m  do
      if(Map.has_key?(movie, k)) do
        {k, Map.get(movie, k)}
      else
        {k, v}
      end
    end
    :ets.insert(:marvel, {String.to_integer(id), Map.new(res)})
    IO.inspect(Map.new(res))
    :ok
  end
end
