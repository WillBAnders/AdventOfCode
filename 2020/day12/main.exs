defmodule Day12 do

  @doc """
  Recursive solution maintaining a direction (0-3) and x/y position.
  """
  def solve1(input), do: solve1(input, 0, 0, 0)
  def solve1([], _, x, y), do: abs(x) + abs(y)
  def solve1([inst | rest], dir, x, y) do
    {dir, x, y} = case inst do
      {"N", dy} -> {dir, x, y + dy}
      {"S", dy} -> {dir, x, y - dy}
      {"E", dx} -> {dir, x + dx, y}
      {"W", dx} -> {dir, x - dx, y}
      {"L", deg} -> {rem(dir + div(deg, 90), 4), x, y}
      {"R", deg} -> {rem(dir + 3 * div(deg, 90), 4), x, y}
      {"F", d} -> case dir do
        0 -> {dir, x + d, y}
        1 -> {dir, x, y + d}
        2 -> {dir, x - d, y}
        3 -> {dir, x, y - d}
      end
    end
    solve1(rest, dir, x, y)
  end

  @doc"""
  Recursive solution using sx/sy for ship position and wx/wy for waypoint
  position relative to the ship. Rotations are handled manually based on the
  rotation direction.
  """
  def solve2(input), do: solve2(input, 0, 0, 10, 1)
  def solve2([], sx, sy, _, _), do: abs(sx) + abs(sy)
  def solve2([inst | rest], sx, sy, wx, wy) do
    {sx, sy, wx, wy} = case inst do
      {"N", dy} -> {sx, sy, wx, wy + dy}
      {"S", dy} -> {sx, sy, wx, wy - dy}
      {"E", dx} -> {sx, sy, wx + dx, wy}
      {"W", dx} -> {sx, sy, wx - dx, wy}
      {"F", d} -> {sx + d * wx, sy + d * wy, wx, wy}
      {lr, deg} -> case rem((if lr == "L" do 1 else 3 end) * div(deg, 90), 4) do
        0 -> {sx, sy, wx, wy}
        1 -> {sx, sy, -wy, wx}
        2 -> {sx, sy, -wx, -wy}
        3 -> {sx, sy, wy, -wx}
      end
    end
    solve2(rest, sx, sy, wx, wy)
  end

end

input = Aoc.inputLines("day12/input.txt")
  |> Enum.map(&({&1 |> String.at(0), &1 |> String.slice(1..-1) |> String.to_integer()}))

IO.inspect(Day12.solve1(input))
IO.inspect(Day12.solve2(input))
