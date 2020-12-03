defmodule Day3 do

  @doc """
  Solves for slope 3, 1
  """
  def solve1(input) do
    solve(input, 0, 0, 3, 1, 0)
  end

  @doc """
  Solves for each slope and reduces by product
  """
  def solve2(input) do
    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
      |> Enum.map(&(solve(input, 0, 0, elem(&1, 0), elem(&1, 1), 0)))
      |> Enum.reduce(1, &*/2)
  end

  @doc """
  Standard recursive solution
  """
  def solve(input, x, y, dx, dy, count) do
    if y < Enum.count(input) do
      line = Enum.at(input, y)
      tree = Enum.at(line, rem(x, Enum.count(line))) == "#"
      solve(input, x + dx, y + dy, dx, dy, count + if tree do 1 else 0 end)
    else count end
  end

end

input = Aoc.inputLines("day3/input.txt")
  |> Enum.map(&String.codepoints/1)

IO.inspect(Day3.solve1(input))
IO.inspect(Day3.solve2(input))
