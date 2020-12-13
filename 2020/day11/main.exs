defmodule Day11 do

  @dirs [{1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {1, -1}]

  @doc"""
  Solution computing neighbors as the next cell for each direction.
  """
  def solve1(input) do
    solve(input, fn map, {x, y} -> @dirs
      |> Enum.map(fn {dx, dy} -> map |> Map.get({x + dx, y + dy}) end)
    end, 4)
  end

  @doc"""
  Solution computing neighbors as the next non-empty cell for each direction.
  """
  def solve2(input) do
    solve(input, fn map, pos -> @dirs
      |> Enum.map(fn dir -> map |> get(pos, dir) end)
    end, 5)
  end

  @doc"""
  Recursively maps all points in the map accordingly to the cellular automaton
  rules until the input and output maps are equal. The neighbors argument is a
  function that computes the neighboring seats considered by a given cell.
  """
  def solve(input, neighbors, max) do
    map = input
      |> Map.to_list()
      |> Enum.map(fn {{x, y}, char} ->
        {{x, y}, case char do
          "L" -> if neighbors.(input, {x, y}) |> Enum.count(&(&1 == "#")) == 0 do "#" else "L" end
          "#" -> if neighbors.(input, {x, y}) |> Enum.count(&(&1 == "#")) >= max do "L" else "#" end
          _ -> char
        end}
      end)
      |> Map.new()
    if Map.equal?(input, map) do map
      |> Map.values()
      |> Enum.count(&(&1 == "#"))
    else solve(map, neighbors, max) end
  end

  @doc"""
  Directional search for part 2, recursively looking in the direction of dx, dy.
  """
  def get(map, {x, y}, {dx, dy}) do
    case map |> Map.get({x + dx, y + dy}) do
      "." -> get(map, {x + dx, y + dy}, {dx, dy})
      char -> char
    end
  end

end

input = Aoc.inputLines("day11/input.txt")
  |> Enum.map(&String.codepoints/1)
  |> Enum.map(&Enum.with_index/1)
  |> Enum.with_index()
  |> Enum.flat_map(fn {list, x} -> list
    |> Enum.map(fn {char, y} -> {{x, y}, char} end)
  end)
  |> Map.new()

IO.inspect(Day11.solve1(input))
IO.inspect(Day11.solve2(input))
