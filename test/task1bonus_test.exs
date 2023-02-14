defmodule Task1BonusTest do
  use ExUnit.Case
  doctest Task1Min

  test "prefix" do
    assert Task1Bonus.commonPrefix(["flower", "flow", "floght"]) == "flo"
    assert Task1Bonus.commonPrefix(["alpha", "beta"]) == ""
  end

  test "roman" do
    assert Task1Bonus.toRoman("13") == "XIII"
    assert Task1Bonus.toRoman("134") == "CXXXIV"
    assert Task1Bonus.toRoman("1") == "I"
  end

  test "factorization" do
    assert Task1Bonus.factorize(42) == [2, 7, 3]
    assert Task1Bonus.factorize(7) == [7]
    assert Task1Bonus.factorize(13) == [13]
  end
end
