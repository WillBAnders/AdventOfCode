defmodule Day17 do

  @unit [-1, 0, 1]

  @doc"""
  Solves for 3d input {x, y, z = 0}
  """
  def solve1(input) do
    input
      |> Enum.map(fn {x, y} -> {x, y, 0} end)
      |> solve()
  end

  @doc"""
  Solves for 4d input {x, y, z = 0, w = 0}
  """
  def solve2(input) do
    input
      |> Enum.map(fn {x, y} -> {x, y, 0, 0} end)
      |> solve()
  end

  @doc"""
  First, collects all neighboring points using Enum.flat_map(&dirs/1), which is
  overloaded for 3d and 4d inputs. Then, map each neighbor according to the
  cellular automaton rules (using flat_map + empty list to filter inactive).
  """
  def solve(input), do: solve(input |> MapSet.new(), 1)
  def solve(input, stage) do
    input = input
      |> Enum.flat_map(&dirs/1)
      |> MapSet.new()
      |> Enum.flat_map(fn vec ->
        active = input |> MapSet.member?(vec)
        neighbors = dirs(vec) |> Enum.count(&(input |> MapSet.member?(&1)))
        if active && neighbors in [2, 3] || !active && neighbors == 3 do [vec] else [] end
      end)
      |> MapSet.new()
    if (stage == 6) do input |> MapSet.size() else solve(input, stage + 1) end
  end

  def dirs({x, y, z}) do
    dirs = for dx <- @unit, dy <- @unit, dz <- @unit, do: {x + dx, y + dy, z + dz}
    dirs -- [{x, y, z}]
  end

  def dirs({x, y, z, w}) do
    dirs = for dx <- @unit, dy <- @unit, dz <- @unit, dw <- @unit, do: {x + dx, y + dy, z + dz, w + dw}
    dirs -- [{x, y, z, w}]
  end

end

input = Aoc.inputLines("day17/input.txt")
  |> Enum.with_index()
  |> Enum.flat_map(fn {line, row} ->
    offset = div(String.length(line), 2)
    line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.filter(fn {char, _} -> char == "#" end)
      |> Enum.map(fn {_, col} -> {row - offset, col - offset} end)
  end)

IO.inspect(Day17.solve1(input))
IO.inspect(Day17.solve2(input))
