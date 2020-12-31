defmodule Day19 do

  def solve1({rules, messages}), do: solve({rules, messages})

  def solve2({rules, messages}) do
    rules = rules
      |> Map.put("8", {:star, ["42"]})
      |> Map.put("11", {:nest, ["42"], ["31"]})
    solve({rules, messages})
  end

  def solve({rules, messages}) do
    pattern = pattern(rules)
    messages
      |> Enum.filter(&(&1 |> String.match?(pattern)))
      |> Enum.count()
  end

  @doc """
  Hacky solution making use of regex and, thankfully, recursive matching.
  """
  def pattern(rules), do: "^#{pattern(rules, rules |> Map.get("0"))}$" |> Regex.compile!()
  def pattern(_, {:char, char}), do: char
  def pattern(rules, {:nums, nums}), do: nums |> Enum.map(&(pattern(rules, rules |> Map.get(&1)))) |> Enum.join()
  def pattern(rules, {:pipe, first, second}), do: "(#{pattern(rules, {:nums, first})}|#{pattern(rules, {:nums, second})})"
  def pattern(rules, {:star, nums}), do: "(#{pattern(rules, {:nums, nums})})+"
  def pattern(rules, {:nest, pre, post}), do: "(?<nest>#{pattern(rules, {:nums, pre})}(?&nest)?#{pattern(rules, {:nums, post})})"

end

[rules, messages] = Aoc.inputParagraphs("day19/input.txt")
rules = rules
  |> Enum.map(fn line ->
    case Regex.run(~r/(\d+): (?:"(.)"|([\d ]+)(?:\|([\d ]+))?)/, line, capture: :all_but_first) do
      [rule, char] -> {rule, {:char, char}}
      [rule, _, nums] -> {rule, {:nums, nums |> String.split(" ", trim: true)}}
      [rule, _, first, second] -> {rule, {:pipe,
        first |> String.split(" ", trim: true),
        second |> String.split(" ", trim: true)
      }}
    end
  end)
  |> Map.new()
input = {rules, messages}

IO.inspect(Day19.solve1(input))
IO.inspect(Day19.solve2(input))
