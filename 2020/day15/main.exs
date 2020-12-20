defmodule Day15 do

  def solve1(input) do
    solve(input, 2020)
  end

  def solve2(input) do
    solve(input, 30000000) #takes a while; unsure if there's an algorithmic solution
  end

  @doc"""
  Starts at turn Enum.count(size) + 2 to ensure the map is in the correct state.
  """
  def solve(input, target) do
    map = input
      |> Enum.with_index(1)
      |> Map.new()
    solve(Enum.count(input) + 2, map, 0, target)
  end

  @doc"""
  Recursive solution terminating when turn - 1 == target (since it tracks the
  number of the last turn). Uses a map for tracking the last turn for a number.
  """
  def solve(turn, map, last, target) do
    if turn - 1 == target do last else
      num = if map |> Map.has_key?(last) do turn - Map.get(map, last) - 1 else 0 end
      solve(turn + 1, Map.put(map, last, turn - 1), num, target)
    end
  end

end

input = Aoc.input("day15/input.txt")
  |> String.split(",", trim: true)
  |> Enum.map(&String.to_integer/1)

IO.inspect(Day15.solve1(input))
IO.inspect(Day15.solve2(input))
