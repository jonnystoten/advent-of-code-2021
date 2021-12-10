defmodule AdventOfCode.Day7 do
  @behaviour AdventOfCode

  def setup(input) do
    crabs =
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    max = Enum.max(crabs)

    %{crabs: crabs, max: max}
  end

  def part1(%{crabs: crabs, max: max}) do
    0..max
    |> Enum.map(fn pos -> fuel_cost_to_postition(crabs, pos) end)
    |> Enum.min()
  end

  def part2(%{crabs: crabs, max: max}) do
    0..max
    |> Enum.map(fn pos -> fuel_cost_to_postition(crabs, pos, &fuel_cost/1) end)
    |> Enum.min()
  end

  defp fuel_cost_to_postition(crabs, pos, cost_func \\ & &1) do
    crabs
    |> Enum.map(&abs(&1 - pos))
    |> Enum.map(&cost_func.(&1))
    |> Enum.sum()
  end

  def fuel_cost(distance) do
    trunc(distance * (distance + 1) / 2)
  end
end
