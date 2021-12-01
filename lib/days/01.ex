defmodule AdventOfCode.Day1 do
  @behaviour AdventOfCode

  def setup(input) do
    depths =
      input
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    %{depths: depths}
  end

  def part1(%{depths: depths}) do
    depths
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> b > a end)
  end

  def part2(%{depths: depths}) do
    depths
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> b > a end)
  end
end
