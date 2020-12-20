defmodule Day16 do

  @doc"""
  Sum all ticket fields where none of the rules match.
  """
  def solve1(input) do
    {rules, _, others} = parse(input)
    others
      |> Enum.flat_map(fn tik -> tik |> Enum.filter(fn num ->
        !Enum.any?(rules, fn {_, r1, r2} -> num in r1 || num in r2 end)
      end) end)
      |> Enum.sum()
  end

  @doc"""
  Starts by filtering invalid tickets and grouping by column. Then, generates
  a set of all matching rules for each column which is resolved to a solution.
  Finally, get the ticket value for each departure rule and reduce by product.
  """
  def solve2(input) do
    {rules, ticket, others} = parse(input)
    others
      |> Enum.filter(fn tik -> tik |> Enum.all?(fn num ->
        Enum.any?(rules, fn {_, r1, r2} -> num in r1 || num in r2 end)
      end) end)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(fn col -> rules
        |> Enum.filter(fn {_, r1, r2} -> col
          |> Enum.all?(fn num -> num in r1 || num in r2 end)
        end)
        |> Enum.map(&(&1 |> elem(0)))
        |> MapSet.new()
      end)
      |> resolve()
      |> Enum.with_index()
      |> Enum.filter(fn {name, _} -> name |> String.starts_with?("departure") end)
      |> Enum.map(fn {_, idx} -> ticket |> Enum.at(idx) end)
      |> Enum.reduce(1, &*/2)
  end

  @doc"""
  Recursively filter rules that are assigned (the only option for a column)
  until all columns are assigned. This assumes a unique solution exists.
  """
  def resolve(columns) do
    assigned = columns
      |> Enum.filter(&(&1 |> MapSet.size() == 1))
      |> Enum.reduce(MapSet.new(), &MapSet.union/2)
    columns = columns
      |> Enum.map(fn rule -> if rule |> MapSet.size() == 1 do rule else
        rule |> MapSet.difference(assigned)
      end end)
    if Enum.count(columns) == MapSet.size(assigned) do
      columns |> Enum.flat_map(&MapSet.to_list/1)
    else resolve(columns) end
  end

  def parse(input) do
    [rules, [_, ticket], [_ | others]] = input
      |> String.split("\n\n", trim: true)
      |> Enum.map(&(&1 |> String.split("\n", trim: true)))
    rules = rules
      |> Enum.map(fn rule ->
        [name, l1, u1, l2, u2] = Regex.run(~r/([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)/, rule, capture: :all_but_first)
        [l1, u1, l2, u2] = [l1, u1, l2, u2] |> Enum.map(&String.to_integer/1)
        {name, l1..u1, l2..u2}
      end)
    [ticket | others] = [ticket | others]
      |> Enum.map(fn t -> t
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
    {rules, ticket, others}
  end

end

input = Aoc.input("day16/input.txt")

IO.inspect(Day16.solve1(input))
IO.inspect(Day16.solve2(input))
