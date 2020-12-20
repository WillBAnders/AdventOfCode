defmodule Day14 do

  @doc """
  Uses Map.merge for applying bitmasks and reduces across each command.
  """
  def solve1(input) do
    input
      |> Enum.map(&parse/1)
      |> Enum.reduce({Map.new(), Map.new()}, fn cmd, {mask, mem} ->
        case cmd do
          {:mask, mask} -> {mask, mem}
          {:write, addr, value} ->
            value = value
              |> intToBits()
              |> Map.merge(mask)
              |> bitsToInt()
            {mask, mem |> Map.put(addr, value)}
        end
      end)
      |> elem(1)
      |> Map.values()
      |> Enum.sum()
  end

  @doc """
  Same concept as part 1, however applies the mask in two parts. First, all bits
  that are explicitly 1 (thus ignoring 0), then 'floating' (X) bits for the
  given permutation.
  """
  def solve2(input) do
    input
      |> Enum.map(&parse/1)
      |> Enum.reduce({Map.new(), Map.new()}, fn cmd, {mask, mem} ->
        case cmd do
          {:mask, mask} -> {mask, mem}
          {:write, addr, value} ->
            mem = perm(36 - Enum.count(mask))
              |> Enum.reduce(mem, fn perm, mem ->
                addr = addr
                  |> intToBits()
                  |> Map.merge(mask
                    |> Map.to_list()
                    |> Enum.filter(&(&1 |> elem(1) == "1"))
                    |> Map.new())
                  |> Map.merge(0..35
                    |> Enum.filter(&(mask |> Map.get(&1) == nil))
                    |> Enum.zip(perm)
                    |> Map.new())
                  |> bitsToInt()
                mem |> Map.put(addr, value)
              end)
            {mask, mem}
        end
      end)
      |> elem(1)
      |> Map.values()
      |> Enum.sum()
  end

  @doc"""
  Regex extraction of commands, using a map for the mask where 'floating' (X)
  bits are excluded.
  """
  def parse(line) do
    case Regex.run(~r/mask = ([10X]{36})|mem\[(\d+)\] = (\d+)/, line, capture: :all_but_first) do
      [mask] -> {:mask, mask
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.filter(&(&1 |> elem(0) != "X"))
        |> Enum.map(fn {idx, char} -> {char, idx} end)
        |> Map.new()}
      [_, addr, value] -> {:write, addr |> String.to_integer(), value |> String.to_integer()}
    end
  end

  def perm(0), do: [[]]
  def perm(n) do
    perm(n - 1) |> Enum.flat_map(fn list -> [["0" | list], ["1" | list]] end)
  end

  def intToBits(int) do
    int
      |> Integer.to_string(2)
      |> String.pad_leading(36, "0")
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {idx, char} -> {char, idx} end)
      |> Map.new()
  end

  def bitsToInt(bits) do
    bits
      |> Map.to_list()
      |> Enum.sort_by(&(&1 |> elem(0) |> Kernel.-()))
      |> Enum.map(&(&1 |> elem(1)))
      |> Enum.reduce("", &<>/2)
      |> String.to_integer(2)
  end

end

input = Aoc.inputLines("day14/input.txt")

IO.inspect(Day14.solve1(input))
IO.inspect(Day14.solve2(input))
