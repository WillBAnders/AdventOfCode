defmodule Day10 do

  @doc"""
  Standard reduce counting the number of differences equaling one or three.
  """
  def solve1(input) do
    {_, one, three} = input |> Enum.reduce({0, 0, 1}, fn num, {prev, one, three} ->
      case num - prev do
        1 -> {num, one + 1, three}
        3 -> {num, one, three + 1}
      end
    end)
    one * three
  end

  @doc """
  Similar process to part 1 using dynamic programing.
  """
  def solve2(input) do
    input |> Enum.reduce({0, 1, 0, 0}, fn num, {prev, one, two, three} ->
      case num - prev do
        1 -> {num, one + two + three, one, two}
        2 -> {num, one + two, one, 0}
        3 -> {num, one, 0, 0}
      end
    end) |> elem(1)
  end

end

input = Aoc.inputLines("day10/input.txt")
  |> Enum.map(&String.to_integer/1)
  |> Enum.sort()

IO.inspect(Day10.solve1(input))
IO.inspect(Day10.solve2(input))
