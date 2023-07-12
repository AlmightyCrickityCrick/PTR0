defmodule Task4Min do

  def get_response() do
    case HTTPoison.get("https://quotes.toscrape.com/") do
      {:ok, %HTTPoison.Response{status_code: code, body: body, headers: head}} ->
        IO.puts("Status code #{code}")
        IO.puts("Headers: ")
        IO.inspect(head)
        IO.puts("Body: ")
        IO.puts(body)
        extract_quotes(body)

    end
  end

  def extract_quotes(body) do
    html = Floki.parse(body)
    #quotes
    IO.puts("----------------------------------------------------")
    q_list = Floki.find(html, ".text")
    q = get_clean_quote(q_list)
    IO.inspect(q)
    #authors
    IO.puts("----------------------------------------------------")
    a_list = Floki.find(html, ".author")
    a= get_author(a_list)
    IO.inspect(a)
    #tags
    IO.puts("----------------------------------------------------")
    t_list = Floki.find(html, ".tags")
    t = get_tags(t_list)
    IO.inspect(t)

    to_json_file(q, a, t)

  end

  def to_json_file(q, aut, tags) do
    data = for i <- 0 .. (length(q) - 1) do
      %{quote: Enum.at(q, i), author: Enum.at(aut, i), tags: Enum.at(tags, i) }
    end
    IO.inspect(data)
    {:ok, json }= Poison.encode(data)
    IO.inspect(json)
    ans = File.write("quotes.json", json, [:write, {:encoding, :utf8}])
    IO.inspect(ans)
  end

  def get_clean_quote(q_list) do
    for q <- q_list do
      tmp = Tuple.to_list(q)
      qq = List.first(Enum.at(tmp, 2))
      clean = String.slice(qq, 1 .. -2)
      clean
    end
  end

  def get_author(a_list) do
    for a <- a_list do
      tmp = Tuple.to_list(a)
      qq = List.first(Enum.at(tmp, 2))
      qq
    end
  end

  def get_tags(t_list) do
    for t <- t_list do
      get_tag(Floki.find(t, ".tag"))
    end
  end

  def get_tag(tag) do
    for t <- tag do
      tmp = Tuple.to_list(t)
      qq = List.first(Enum.at(tmp, 2))
      qq
    end
  end

end
