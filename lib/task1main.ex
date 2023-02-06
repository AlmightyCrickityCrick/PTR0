defmodule Task1Main do

  def removeConsecutiveDuplicates(lst) do
    lst1 = for x <- 0 .. (length(lst) - 1) do
      if(x < 1 or Enum.at(lst, x) != Enum.at(lst, x-1)) do
        Enum.at(lst, x)
      end
    end
    res = Enum.filter(lst1, &!is_nil(&1))
    IO.inspect(res, charlists: :as_lists)
    res
  end

  def checkLine(word, linechar) do
    tmp = String.downcase(word)
    tmp = String.graphemes(tmp)
    res = for x <- tmp do
      String.contains?(linechar, x)
    end
    !Enum.member?(res, false)
  end

  def lineWords(lst) do
    line1 = "qwertyuiop"
    line2 = "asdfghjkl"
    line3 = "zxcvbnm"

    res = for x <- lst do
      if(checkLine(x, line1) or checkLine(x, line2) or checkLine(x, line3)) do x end
    end
    res = Enum.filter(res, &!is_nil(&1))
    IO.inspect(res, charlists: :as_lists)
    res

  end

  def encode(word, nr) do
    lst = String.to_charlist(word)
    ciphertext = for x <- lst do
      x + nr
    end
    IO.puts(ciphertext)
    ciphertext
  end

  def decode(word, nr) do
    lst = String.to_charlist(word)
    plaintext = for x <- lst do
      x - nr
    end
    IO.puts(plaintext)
    plaintext
  end

  def recursiveLetter(lst) do
    encoding = %{
      50 => ['a','b', 'c'],
      51 => ['d', 'e', 'f'],
      52 => ['g', 'h', 'i'],
      53 => ['j', 'k', 'l'],
      54 => ['m', 'n', 'o'],
      55 => ['p', 'q', 'r', 's'],
      56 => ['t', 'u', 'v'],
      57 => ['w', 'x', 'y', 'z']
    }
    [head|tail] = lst

    if(tail == []) do
      result = encoding[head]
      result
    else
    result =
      for x <- encoding[head], y <- recursiveLetter(tail) do
      "#{x}#{y}"
      end
    result
  end
  end

  def letterCombinations(str) do
    tmp = String.to_charlist(str)
    res = recursiveLetter(tmp)
    IO.inspect(res, charlists: :as_lists)
    res
  end

  def addToMap([], map) do map end

  def addToMap([head|tail], map) do
    IO.puts(head)
    tmp = List.to_string(Enum.sort(String.to_charlist(head)))

    if(Map.has_key?(map, tmp)) do
      m = Map.get_and_update(map, tmp, fn current_value -> {current_value, Enum.sort(List.insert_at(current_value, -1, head))} end)
      res = addToMap(tail, elem(m, 1))
      res
    else
      m =  Map.get_and_update(map, tmp, fn current_value -> {current_value, [head]} end)
      res = addToMap(tail, elem(m, 1))
      res
    end

  end

  def groupAnagrams(lst) do
    res = addToMap(lst, %{})
    IO.inspect(res)
  end

end
