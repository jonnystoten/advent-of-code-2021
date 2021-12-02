defmodule AdventOfCode.Day2 do
  @behaviour AdventOfCode

  def setup(input) do
    commands =
      input
      |> String.split("\n")
      |> Enum.map(&String.split/1)
      |> Enum.map(fn [com, num] -> {com, String.to_integer(num)} end)

    %{commands: commands}
  end

  def part1(%{commands: commands}) do
    {x, y} = Enum.reduce(commands, {0, 0}, &move/2)
    x * y
  end

  defp move({"forward", num}, {x, y}), do: {x + num, y}
  defp move({"down", num}, {x, y}), do: {x, y + num}
  defp move({"up", num}, {x, y}), do: {x, y - num}

  def part2(%{commands: commands}) do
    {x, y, _aim} = Enum.reduce(commands, {0, 0, 0}, &move_with_aim/2)
    x * y
  end

  defp move_with_aim({"forward", num}, {x, y, aim}), do: {x + num, y + (num*aim), aim}
  defp move_with_aim({"down", num}, {x, y, aim}), do: {x, y, aim + num}
  defp move_with_aim({"up", num}, {x, y, aim}), do: {x, y, aim - num}
end
