defmodule Day13 do

  @doc"""
  Straightforward solution using remainders to calculate wait time.
  """
  def solve1([time, busses]) do
    time = time |> String.to_integer()
    {wait, bus} = busses
      |> String.split(",", trim: true)
      |> Enum.filter(&(&1 != "x"))
      |> Enum.map(&String.to_integer/1)
      |> Enum.map(&({&1 - rem(time, &1), &1}))
      |> Enum.min_by(&(&1 |> elem(0)))
    wait * bus
  end

  @doc"""
  This is a greedy solution that depends on all bus ids being relatively prime.

  For any input, let {start, period} be the starting time of a solution and the
  least common multiple of all bus ids. Since each bus id is a factor of period,
  note start + n * period is also a valid solution (just not the earliest).

  Let {bus, idx} be the bus id and its zero-based index in the list. This bus
  leaves the station at times bus * i. The trip that continues this pattern is
  the point where bus * i === start + idx (mod period). Solving this, we can use
  i to determine which period this trip falls under to calculate the new start,
  and the new period is simply period * bus (relatively prime).
  """
  def solve2([_, busses]) do
    busses
      |> String.split(",", trim: true)
      |> Enum.with_index()
      |> Enum.filter(&(&1 |> elem(0) != "x"))
      |> Enum.map(&({&1 |> elem(0) |> String.to_integer(), &1 |> elem(1)}))
      |> Enum.reduce({0, 1}, fn {bus, idx}, {start, period} ->
        {start + div(bus * solveMod(bus, start + idx, period), period) * period, period * bus}
      end)
      |> elem(0)
  end

  #https://www.geeksforgeeks.org/multiplicative-inverse-under-modulo-m/
  def solveMod(a, b, m) do
    rem(b * rem(rem(gcd(a, m) |> elem(0), m) + m, m), m)
  end

  def gcd(0, _), do: {0, 1}
  def gcd(a, b) do
    {x, y} = gcd(rem(b, a), a)
    {y - div(b, a) * x, x}
  end


end

input = Aoc.inputLines("day13/input.txt")

IO.inspect(Day13.solve1(input))
IO.inspect(Day13.solve2(input))
