defmodule Aoc do

  def input(name), do: File.read!(name)

  def inputLines(name), do: input(name) |> String.split("\n", trim: true)

end
