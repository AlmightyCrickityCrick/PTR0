defmodule Task1Bonus do

def commonPrefix(lst) do
  minlength = for x <- lst do String.length(x) end
  minlength = Enum.min(minlength)

  repeating = for x <- 0 .. (minlength - 1) do
    repeat1 = for word <- lst do String.at(word, x) end
    if(length(Enum.uniq(repeat1)) == 1) do Enum.at(repeat1, 0) else "" end
  end

  notSame = Enum.find_index(repeating, fn x -> x == "" end)
  res = Enum.slice(repeating, 0 .. notSame)
  IO.puts(res)
  Enum.join(res, "")
end


def toRoman(nr) when is_bitstring(nr) do
  res = toRoman(String.to_integer(nr))
  IO.puts(res)
  res
end


def toRoman(nr) when nr >= 900 do
  if(nr < 1000) do
    "CM#{toRoman(nr-900)}"
  else
    x = String.duplicate("M", div(nr, 1000))
    "#{x}#{toRoman(rem(nr, 1000))}"
  end

end

def toRoman(nr) when nr >= 400 do
  if(nr < 500) do
    "CD#{toRoman(nr-400)}"
  else
    x = String.duplicate("D", div(nr, 500))
    "#{x}#{toRoman(rem(nr, 500))}"
  end

end

def toRoman(nr) when nr >= 90 do
  if(nr < 100) do
    "XC#{toRoman(nr-90)}"
  else
    x = String.duplicate("C", div(nr, 100))
    "#{x}#{toRoman(rem(nr, 100))}"
  end

end

def toRoman(nr) when nr >= 40 do
  if(nr < 50) do
    "XL#{toRoman(nr-40)}"
  else
    x = String.duplicate("L", div(nr, 50))
    "#{x}#{toRoman(rem(nr, 50))}"
  end

end

def toRoman(nr) when nr >= 9 do
  if(nr < 10) do
    "IX#{toRoman(nr-9)}"
  else
    x = String.duplicate("X", div(nr, 10))
    "#{x}#{toRoman(rem(nr, 10))}"
  end

end

def toRoman(nr) when nr >= 4 do
  if(nr < 5) do
    "IV#{toRoman(nr-4)}"
  else
    x = String.duplicate("V", div(nr, 5))
    "#{x}#{toRoman(rem(nr, 5))}"
  end

end

def toRoman(nr) when nr > 0 do
    x = String.duplicate("I", div(nr, 1))
    "#{x}#{toRoman(rem(nr, 1))}"

end

def toRoman(0) do "" end

def factorize(nr) when rem(nr,2) == 0 do
  if(Task1Min.isPrime(nr)) do
    [nr]
  else
    List.flatten([2, factorize(div(nr, 2))])
  end
end

def factorize(nr) when rem(nr, 2) == 1 do
  import :math
  if(Task1Min.isPrime(nr) or nr == 3) do
    [nr]
  else
    tmp = for x <- 3..(nr-1)//2 do
      if(rem(nr, x) == 0) do x end
    end
    tmp = Enum.filter(tmp, &!is_nil(&1))
    factor = Enum.max(tmp)
    IO.puts("Factor #{factor}")
    IO.inspect(tmp, charlists: :as_lists)
    List.flatten([factor, factorize(div(nr, factor))])
  end
end

end
