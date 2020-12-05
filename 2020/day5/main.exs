defmodule Day5 do

  def solve1(input) do
    input
      |> Enum.map(&id/1)
      |> Enum.max()
  end

  def solve2(input) do
    ids = input |> Enum.map(&id/1)
    idx = ids |> Enum.find(fn id -> !Enum.member?(ids, id + 1) && Enum.member?(ids, id + 2) end)
    idx + 1
  end

  def id(seat) do
    offsets = [64, 32, 16, 8, 4, 2, 1, 4, 2, 1]
    [row, col] = seat
                 |> String.codepoints()
                 |> Enum.with_index()
                 |> Enum.map(fn {x, i} -> if x == "F" || x == "L" do 0 else Enum.at(offsets, i) end end)
                 |> Enum.chunk_every(7)
                 |> Enum.map(&Enum.sum/1)
    8 * row + col
  end

end

input = Aoc.inputLines("day5/input.txt")

IO.inspect(Day5.solve1(input))
IO.inspect(Day5.solve2(input))
