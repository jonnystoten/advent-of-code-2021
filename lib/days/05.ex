defmodule AdventOfCode.Day5 do
  @behaviour AdventOfCode

  def setup(input) do
    lines =
      input
      |> String.split("\n")
      |> Enum.map(fn line ->
        [_, x1, y1, x2, y2] = Regex.run(~r{(\d+),(\d+) -> (\d+),(\d+)}, line)

        {
          {String.to_integer(x1), String.to_integer(y1)},
          {String.to_integer(x2), String.to_integer(y2)}
        }
      end)

    %{lines: lines}
  end

  def part1(%{lines: lines}) do
    lines
    |> Enum.filter(fn
      {{x, _y1}, {x, _y2}} -> true
      {{_x1, y}, {_x2, y}} -> true
      _ -> false
    end)
    |> overlap_points()
  end

  def part2(%{lines: lines}) do
    lines
    |> overlap_points()
  end

  defp overlap_points(lines) do
    lines
    |> Enum.reduce(%{}, fn {{x1, y1}, {x2, y2}}, grid ->
      points = points({x1, y1}, {x2, y2})

      Enum.reduce(points, grid, fn point, grid ->
        Map.update(grid, point, 1, &(&1 + 1))
      end)
    end)
    |> Enum.count(fn {_, count} -> count > 1 end)
  end

  defp points(start, finish) do
    {step_x, step_y} = step(start, finish)
    points(start, finish, step_x, step_y, [])
  end

  defp points({x, y}, {x, y}, _stepx, _stepy, result), do: [{x, y} | result]

  defp points({x1, y1}, finish, step_x, step_y, result) do
    points({x1 + step_x, y1 + step_y}, finish, step_x, step_y, [{x1, y1} | result])
  end

  defp step({x1, y1}, {x2, y2}), do: {direction(x1, x2), direction(y1, y2)}

  defp direction(a, a), do: 0
  defp direction(a, b) when a < b, do: 1
  defp direction(a, b) when a > b, do: -1
end
