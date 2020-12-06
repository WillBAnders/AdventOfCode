defmodule Aoc do

  def input(name), do: File.read!(name)

  def inputLines(name), do: input(name) |> String.split("\n", trim: true)

  def inputParagraphs(name), do: input(name)
    |> String.split("\n\n", trim: true)
    |> Enum.map(&(&1 |> String.split("\n", trim: true)))

end
