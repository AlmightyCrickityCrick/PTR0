defmodule Task1MainTest do
  use ExUnit.Case
  doctest Task1Main

  test "consec duplicates" do
    assert Task1Main.removeConsecutiveDuplicates([1,2,2,2,4,8,4]) == [1,2,4,8,4]
  end

  test "in one line" do
    assert Task1Main.lineWords(["Hello", "Alaska", "Dad", "Peace"]) == ["Alaska", "Dad"]
  end

  test "caesar" do
    assert Task1Main.encode("lorem", 3) == 'oruhp'
    assert Task1Main.decode("oruhp", 3) == 'lorem'
  end

  test "lettercomb" do
    assert Task1Main.letterCombinations("23") == ["ad", "ae", "af", "bd", "be", "bf", "cd", "ce", "cf"]
  end

  test "anagrams" do
    assert Task1Main.groupAnagrams(["eat", "tea", "tan", "ate", "nat", "bat"]) == %{
      "abt" => ["bat"],
      "ant" => ["nat", "tan"],
      "aet" => ["ate", "eat", "tea"]

    }
  end
end
