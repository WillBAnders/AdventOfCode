defmodule Day2 do

  @doc """
  Uses a range check for the count of codepoints
  """
  def solve1(input) do
    input
      |> Enum.filter(fn [lower, upper, char, pass] ->
        range = String.to_integer(lower)..String.to_integer(upper)
        count = Enum.count(String.codepoints(pass), &(&1 == char))
        Enum.member?(range, count)
      end)
      |> Enum.count()
  end

  @doc """
  Trivial solution with indexed character access
  """
  def solve2(input) do
    input
      |> Enum.filter(fn [pos1, pos2, char, pass] ->
        valid1 = Enum.at(String.codepoints(pass), String.to_integer(pos1) - 1) == char
        valid2 = Enum.at(String.codepoints(pass), String.to_integer(pos2) - 1) == char
        valid1 && !valid2 || !valid1 && valid2
      end)
      |> Enum.count()
  end

end

#Regex is the saving grace, but couldn't get it quite how I wanted in Elixir.
input = Aoc.inputLines("day2/input.txt")
  |> Enum.map(&(Regex.run(~r/(\d+)-(\d+) ([a-z]): ([a-z]+)/, &1) |> tl))

IO.inspect(Day2.solve1(input))
IO.inspect(Day2.solve2(input))
