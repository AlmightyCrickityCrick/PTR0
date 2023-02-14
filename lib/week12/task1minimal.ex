defmodule Task1Min do
  def hello do
    IO.puts("Hello PTR")
    "Hello PTR"
  end


  def isPrime(number) do
    values = for x <- 2..(number-1) do
      rem(number, x)
    end

    IO.inspect(values, charlists: :as_lists)

    res = if (Enum.member?(values, 0) and (number != 2) and (number != 3)) do false else true end
    IO.puts(res)
    res
    end

    def cylinderArea(h, r) do
      import :math
      area =(2 * pi() * r * h) + (2 * pi() * r * r)
      IO.puts(area)
      area
    end

    def reverseList(lst) do
      lst1 = for x <- (length(lst)-1)..0//-1 do
        Enum.at(lst, x)
      end
      IO.inspect(lst1, charlists: :as_lists)
      lst1
    end

    def sumUnique(lst) do
      lst1 = Enum.uniq(lst)
      IO.inspect(lst1, charlists: :as_lists)
      IO.puts(Enum.sum(lst1))
    end

    def extractRandom(lst, nr) do
      lst1 = for _x <- 1 .. nr  do
        Enum.at(lst, Enum.random(0 .. length(lst)-1))
      end
      IO.inspect(lst1, charlists: :as_lists)
      lst1
    end

    def fib(0) do
      0
    end

    def fib(1) do
      1
    end

    def fib(n) do
      fib(n - 1) + fib(n - 2)
    end

    def firstFibonacciElements(n) do
      lst1 = for x <- 1 .. n  do
        fib(x)

      end
      IO.inspect(lst1, charlists: :as_lists)
      lst1
    end

    def translator(dict, str) do
      strList = String.split(str, " ")
      str1 = for x <- strList do
        if(dict[x] != nil) do dict[x] else x end
      end
      res = Enum.join(str1, " ")
      IO.inspect(res, charlists: :as_lists)
      res

    end

    def changeToNonZero(ordered) do
      zeroIndices = for i <- 0 .. length(ordered)-1 do if(Enum.at(ordered, i)== 0) do i end end
        zeroIndices = Enum.filter(zeroIndices, &!is_nil(&1))
        res1 = List.replace_at(ordered, 0, Enum.at(ordered, List.last(zeroIndices)+1))
        res = List.replace_at(res1, List.last(zeroIndices)+1, 0)
        res
    end

    def smallestNumber(lst) do
      ordered = Enum.sort(lst)
      if Enum.member?(ordered, 0) do
        x = changeToNonZero(ordered)
        z = Enum.join(x, "")
        res = String.to_integer(z)
        IO.puts(res)
        res
      else
        z = Enum.join(ordered, "")
        res = String.to_integer(z)
        IO.puts(res)
        res
      end
    end

      def smallestNumber(a, b, c) do
        smallestNumber([a,b,c])
      end

      def rotateLeft(lst, nr) do
        lst1 = for x <- nr .. (nr + length(lst) - 1) do
          Enum.at(lst, rem(x, length(lst)))
        end
        IO.inspect(lst1, charlists: :as_lists)
        lst1
      end

      def listRightAngleTriangles() do
        import :math
        lst = for i <- 1..20, j <- 1..20 do
          c = sqrt(i*i+j*j)
          if(c == trunc(c)) do {i, j, trunc(c)} end
        end
        res = Enum.filter(lst, &!is_nil(&1))
        IO.inspect(res, charlists: :as_lists)
        res
      end

  end
