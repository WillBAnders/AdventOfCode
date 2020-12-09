defmodule Day9 do

  @doc """
  Splits the input into the starting preamble (reversed for FIFO) and rest.
  """
  def solve1(input) do
    {preamble, rest} = input |> Enum.split(25)
    solve1(preamble |> Enum.reverse(), rest)
  end

  @doc """
  Recurses while any pair (via comb) of the previous 25 numbers sums to the
  target number.
  """
  def solve1(_, []), do: nil
  def solve1(nums, [num | rest]) do
    if nums |> Enum.take(25) |> comb(2) |> Enum.any?(&(Enum.sum(&1) == num)) do
      solve1([num | nums], rest)
    else num end
  end

  @doc """
  Calls &solve2/3 for every subsequence with a new first element, returning the
  first non-nil result.
  """
  def solve2(input) do
    target = solve1(input)
    1..Enum.count(input)
      |> Enum.map(fn idx ->
        solve2([], input |> Enum.drop(idx - 1), target)
      end)
      |> Enum.find(&(&1 != nil))
  end

  @doc """
  Recursively checks sequences of numbers, returning min + max if the sum equals
  the target otherwise continuing/stopping recursion accordingly.
  """
  def solve2(_, [], _), do: nil
  def solve2(nums, [num | rest], target) do
    case Enum.sum(nums) do
      sum when sum < target -> solve2([num | nums], rest, target)
      sum when sum > target -> nil
      _ -> Enum.min(nums) + Enum.max(nums)
    end
  end

  #https://rosettacode.org/wiki/Combinations#Elixir
  def comb(_, 0), do: [[]]
  def comb([], _), do: []
  def comb([h|t], m) do
    (for l <- comb(t, m-1), do: [h|l]) ++ comb(t, m)
  end

end

input = Aoc.inputLines("day9/input.txt")
  |> Enum.map(&String.to_integer/1)

IO.inspect(Day9.solve1(input))
IO.inspect(Day9.solve2(input))
