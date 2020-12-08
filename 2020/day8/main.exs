defmodule Day8 do

  def solve1(input) do
    input
      |> Enum.map(&parse/1)
      |> solve(0, MapSet.new(), 0)
      |> elem(1)
  end

  @doc"""
  Iterates each instruction, swapping nop/jmp where applicable.
  """
  def solve2(input) do
    program = input |> Enum.map(&parse/1)
    program
      |> Enum.with_index()
      |> Enum.map(fn {{inst, arg}, idx} ->
        case inst do
          "nop" -> solve(replace(program, idx, {"jmp", arg}), 0, MapSet.new(), 0)
          "jmp" -> solve(replace(program, idx, {"nop", arg}), 0, MapSet.new(), 0)
          _ -> {:inf, -1}
        end
      end)
      |> Enum.find(&(elem(&1, 0) == :fin))
      |> elem(1)
  end

  @doc"""
  Replaces the element at an index with value
  """
  def replace(list, idx, value) do
    Enum.concat([Enum.take(list, idx), [value], Enum.drop(list, idx + 1)])
  end

  @doc"""
  Recursively evaluates instructions until the current instruction has been
  visited, returning {:inf, acc} or the end of the list is reached {:fin, acc}.
  """
  def solve(program, idx, visited, acc) do
    if Enum.member?(visited, idx) do {:inf, acc} else
      case program |> Enum.at(idx) do
        {"nop", _} -> solve(program, idx + 1, MapSet.put(visited, idx), acc)
        {"acc", arg} -> solve(program, idx + 1, MapSet.put(visited, idx), acc + arg)
        {"jmp", arg} -> solve(program, idx + arg, MapSet.put(visited, idx), acc)
        nil -> {:fin, acc}
      end
    end
  end

  def parse(line) do
    [inst, num] = line |> String.split(" ")
    {inst, String.to_integer(num)}
  end

end

input = Aoc.inputLines("day8/input.txt")

IO.inspect(Day8.solve1(input))
IO.inspect(Day8.solve2(input))
