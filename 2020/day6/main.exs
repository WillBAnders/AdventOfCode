defmodule Day6 do

  @doc """
  Reduces via set union starting from empty set.
  """
  def solve1(input) do
    solve(input, MapSet.new(), &MapSet.union/2)
  end

  @doc """
  Reduces via set intersection starting from full alphabet.
  """
  def solve2(input) do
    solve(input, MapSet.new(String.codepoints("abcdefghijklmnopqrstuvwxyz")), &MapSet.intersection/2)
  end

  @doc """
  Uses a set of characters for each line in a group and reduces from the given
  start value via the reduce function.
  """
  def solve(input, start, reduce) do
    input
      |> Enum.map(fn group -> group
        |> Enum.map(&String.codepoints/1)
        |> Enum.map(&MapSet.new/1)
        |> Enum.reduce(start, reduce)
        |> Enum.count()
      end)
      |> Enum.sum()
  end

end

input = Aoc.inputParagraphs("day6/input.txt")

IO.inspect(Day6.solve1(input))
IO.inspect(Day6.solve2(input))
