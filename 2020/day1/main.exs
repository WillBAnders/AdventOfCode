defmodule Day1 do

  @doc """
  Uses set intersection to filter elements in a pair summing to 2020. Based on
  the idea that if an element is part of a pair then the list must contain the
  value 2020 - element as well.

  This uses a number of tricks for anonymous functions and function references.
  """
  def solve1(list) do
    a = MapSet.new(list)
    b = MapSet.new(Enum.map(list, &(2020 - &1)))
    MapSet.intersection(a, b)
      |> MapSet.to_list
      |> Enum.reduce(1, &*/2) #A reference to the * function
  end

  @doc """
  Generates all combinations of three elements (see below), finding the first
  that sums to 2020.
  """
  def solve2(list) do
    comb(3, list)
      |> Enum.find(&(Enum.sum(&1) == 2020))
      |> Enum.reduce(1, &*/2)
  end

  #https://rosettacode.org/wiki/Combinations#Elixir
  def comb(0, _), do: [[]]
  def comb(_, []), do: []
  def comb(m, [h|t]) do
    (for l <- comb(m-1, t), do: [h|l]) ++ comb(m, t)
  end

end

input = Aoc.inputLines("day1/input.txt")
  |> Enum.map(&String.to_integer/1)

IO.inspect(Day1.solve1(input))
IO.inspect(Day1.solve2(input))
