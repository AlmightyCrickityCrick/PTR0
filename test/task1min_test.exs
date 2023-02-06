defmodule Task1MinTest do
  use ExUnit.Case
  doctest Task1Min

  test "greets the world" do
    assert Task1Min.hello() == "Hello PTR"
  end

  test "not prime" do
    assert Task1Min.isPrime(14) == false
  end

  test "prime" do
    assert Task1Min.isPrime(13) == true
  end

  test "two" do
    assert Task1Min.isPrime(2) == true
  end

  test "three" do
    assert Task1Min.isPrime(3) == true
  end

  test "area1" do
    import :math
    assert round(Task1Min.cylinderArea(3, 4)) == 176
  end

  test "reverse" do
    assert Task1Min.reverseList([1, 2, 4, 8, 4]) == [4, 8, 4, 2, 1]
  end

  test "fib" do
    assert Task1Min.firstFibonacciElements(7) == [1,1,2,3,5,8,13]
  end

  test "translator" do
    dict = %{
      "mama" => "mother",
      "papa" => "father"
    }

    original = "mama is with papa"
    assert Task1Min.translator(dict, original) == "mother is with father"
  end

  test "smallestnumber" do
    assert Task1Min.smallestNumber(0, 3, 4) == 304
    assert Task1Min.smallestNumber(4,5,2) == 245
  end

  test "rotateLeft" do
    assert Task1Min.rotateLeft([1,2,4,8,4], 3) == [8,4,1,2,4]
  end

  test "triangle" do
    assert Task1Min.listRightAngleTriangles() == [
      {3, 4, 5},
      {4, 3, 5},
      {5, 12, 13},
      {6, 8, 10},
      {8, 6, 10},
      {8, 15, 17},
      {9, 12, 15},
      {12, 5, 13},
      {12, 9, 15},
      {12, 16, 20},
      {15, 8, 17},
      {15, 20, 25},
      {16, 12, 20},
      {20, 15, 25}
    ]
  end

end
