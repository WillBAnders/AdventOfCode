defmodule Day4 do

  @doc """
  Checks for 8 fields or 7 when missing cid. Assumes all fields are known.
  """
  def solve1(input) do
    input |> Enum.count(&(Enum.count(&1) == 8 || Enum.count(&1) == 7 && Map.get(&1, "cid") == nil))
  end

  @doc """
  Regex patterns for validating each field. Number ranges can be checked using
  combinations of regex's, such as 19[2-9][0-9]|200[0-2] being 1920-2002.
  """
  def solve2(input) do
    input
      |> Enum.filter(&(Enum.count(&1) == 8 || Enum.count(&1) == 7 && Map.get(&1, "cid") == nil))
      |> Enum.count(fn map -> map |> Enum.all?(fn {key, value} ->
        case key do
          "byr" -> value |> String.match?(~r/19[2-9][0-9]|200[0-2]/)
          "iyr" -> value |> String.match?(~r/201[0-9]|2020/)
          "eyr" -> value |> String.match?(~r/202[0-9]|2030/)
          "hgt" -> value |> String.match?(~r/1[5-8][0-9]cm|19[0-3]cm|59in|6[0-9]in|7[0-6]in/)
          "hcl" -> value |> String.match?(~r/#[0-9a-f]{6}/)
          "ecl" -> value |> String.match?(~r/amb|blu|brn|gry|grn|hzl|oth/)
          "pid" -> value |> String.match?(~r/^[0-9]{9}$/) #Note anchors, thanks Elixir :/
          "cid" -> true
        end
      end) end)
  end

end

input = Aoc.input("day4/input.txt")
  |> String.split("\n\n", trim: true)
  |> Enum.map(fn passport -> passport
      |> String.split(~r/\s/, trim: true)
      |> Enum.map(&(&1 |> String.split(":") |> List.to_tuple()))
      |> Map.new()
  end)

IO.inspect(Day4.solve1(input))
IO.inspect(Day4.solve2(input))
