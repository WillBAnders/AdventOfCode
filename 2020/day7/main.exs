defmodule Day7 do

  def solve1(input) do
    input
      |> Enum.map(&parse/1)
      |> Map.new()
      |> solve1(MapSet.new(["shiny gold"]))
  end

  @doc """
  Brute force solutions repeatedly accumulating bags containing a bag in the
  current solution. Terminates when no bags are added in an iteration.
  """
  def solve1(bags, acc) do
    res = Enum.reduce(bags, acc, fn {bag, contains}, acc ->
      if Enum.any?(acc, &(Map.has_key?(contains, &1))) do MapSet.put(acc, bag) else acc end
    end)
    if Enum.count(res) == Enum.count(acc) do Enum.count(res) - 1 else solve1(bags, res) end
  end

  def solve2(input) do
    input
      |> Enum.map(&parse/1)
      |> Map.new()
      |> solve2("shiny gold")
  end

  @doc"""
  Brute force solution counting the number of bags contained within bag.
  """
  def solve2(bags, bag) do
    bags
      |> Map.get(bag)
      |> Enum.map(fn {b, q} -> (solve2(bags, b) + 1) * q end)
      |> Enum.sum()
  end

  @doc"""
  Uses a mix of string split & regex to extract the name of the bag and a map of
  contained bags to quantity.
  """
  def parse(rule) do
    [bag, contains] = rule |> String.split(" bags contain ")
    contains = if contains == "no other bags." do MapSet.new() else contains
      |> String.split(", ")
      |> Enum.map(fn l ->
        [_, quantity, bag] = Regex.run(~r/(\d+) ([a-z ]+) bag/, l)
        {bag, String.to_integer(quantity)}
      end)
      |> Map.new()
    end
    {bag, contains}
  end

end

input = Aoc.inputLines("day7/input.txt")

IO.inspect(Day7.solve1(input))
IO.inspect(Day7.solve2(input))
