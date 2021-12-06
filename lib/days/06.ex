defmodule AdventOfCode.Day6 do
  @behaviour AdventOfCode

  def setup(input) do
    fish =
      input
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    %{fish: fish}
  end

  def part1(%{fish: fish}) do
    fish
    |> simulate(80)
    |> length()
  end

  defp simulate(fish, 0) do
    fish
  end

  defp simulate(fish, t) do
    simulate(fish, t, [])
  end

  defp simulate([], t, result) do
    simulate(result, t - 1)
  end

  defp simulate([0 | tail], t, result) do
    simulate(tail, t, [8, 6 | result])
  end

  defp simulate([head | tail], t, result) do
    simulate(tail, t, [head - 1 | result])
  end

  def part2(%{fish: fish}) do
    fish
    |> Enum.frequencies()
    |> simulate_fast(256)
    |> Map.values()
    |> Enum.sum()
  end

  defp simulate_fast(fish, 0) do
    fish
  end

  defp simulate_fast(fish, t) do
    zeros = Map.get(fish, 0, 0)

    fish =
      Enum.reduce(1..8, fish, fn key, fish ->
        count = Map.get(fish, key, 0)
        Map.put(fish, key - 1, count)
      end)

    fish =
      fish
      |> Map.update(6, zeros, &(&1 + zeros))
      |> Map.put(8, zeros)

    simulate_fast(fish, t - 1)
  end
end
