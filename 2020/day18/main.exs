#Note: having written many parsers, I wanted to try to solve this without any
#type of pre parsing or tree traversal. This was the result.
defmodule Day18 do

  def solve1(input) do
    input
      |> Enum.map(&solve1init/1)
      |> Enum.sum()
  end

  @doc"""
  Initial evaluation for either open parentheses or starting number.
  """
  def solve1init(input) do
    case input do
      ["(" | rest] ->
        {rest, acc} = solve1init(rest)
        solve1cont(rest, acc)
      [num | rest] ->
        solve1cont(rest, String.to_integer(num))
    end
  end

  @doc"""
  Continued evaluation building off an accumulator. Closing parentheses return
  a {rest, acc} tuple which is handled by open parentheses cases and turned into
  the appropriate input.
  """
  def solve1cont(input, acc) do
    case input do
      [] -> acc
      [")" | rest] -> {rest, acc}
      [op, "(" | rest] ->
        {rest, a} = solve1init(rest)
        solve1cont([op, Integer.to_string(a) | rest], acc)
      ["+", num | rest] -> solve1cont(rest, acc + String.to_integer(num))
      ["*", num | rest] -> solve1cont(rest, acc * String.to_integer(num))
    end
  end

  def solve2(input) do
    input
      |> Enum.map(&solve2init/1)
      |> Enum.sum()
  end

  @doc"""
  Same as solve1init
  """
  def solve2init(input) do
    case input do
      ["(" | rest] ->
        {rest, acc} = solve2init(rest)
        solve2cont(rest, acc)
      [num | rest] ->
        solve2cont(rest, String.to_integer(num))
    end
  end

  @doc"""
  Same as solve2init, but adds an additional case for + after * (increased
  priority). Since this can also happen inside of parentheses, we need to handle
  the special {rest, acc} result and reinsert the necessary closing parentheses.
  """
  def solve2cont(input, acc) do
    case input do
      [] -> acc
      [")" | rest] -> {rest, acc}
      [op, "(" | rest] ->
        {rest, a} = solve2init(rest)
        solve2cont([op, Integer.to_string(a) | rest], acc)
      ["+", num | rest] -> solve2cont(rest, acc + String.to_integer(num))
      ["*", num, "+" | rest] ->
        case solve2init([num, "+" | rest]) do
          {rest, a} -> solve2cont(["*", Integer.to_string(a), ")" | rest], acc)
          a -> solve2cont(["*", Integer.to_string(a)], acc)
        end
      ["*", num | rest] -> solve2cont(rest, acc * String.to_integer(num))
    end
  end

end

input = Aoc.inputLines("day18/input.txt")
  |> Enum.map(fn line -> line
    |> String.codepoints()
    |> Enum.filter(&(&1 != " "))
  end)

IO.inspect(Day18.solve1(input))
IO.inspect(Day18.solve2(input))
