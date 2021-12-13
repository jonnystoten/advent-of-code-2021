defmodule AdventOfCode.Day9 do
  @behaviour AdventOfCode

  def setup(input) do
    lines =
      input
      |> String.split("\n")

    heightmap =
      lines
      |> Enum.map(fn line ->
        String.graphemes(line)
      end)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> Enum.with_index()
        |> Enum.map(fn {ch, x} -> {{x, y}, String.to_integer(ch)} end)
      end)
      |> Map.new()

    %{heightmap: heightmap, max_x: Enum.at(lines, 0) |> String.length(), max_y: length(lines)}
  end

  def part1(%{heightmap: heightmap, max_x: max_x, max_y: max_y}) do
    low_points(heightmap, max_x, max_y)
    |> Enum.map(&risk_level(&1, heightmap))
    |> Enum.sum()
  end

  def part2(%{heightmap: heightmap, max_x: max_x, max_y: max_y}) do
    low_points(heightmap, max_x, max_y)
    |> Enum.map(&basin_size(&1, max_x, max_y, heightmap))
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp low_points(heightmap, max_x, max_y) do
    for x <- 0..max_x, y <- 0..max_y, low_point({x, y}, max_x, max_y, heightmap) do
      {x, y}
    end
  end

  defp basin_size(point, max_x, max_y, heightmap) do
    MapSet.new()
    |> basin(point, max_x, max_y, heightmap)
    |> MapSet.size()
  end

  defp basin(set, point, max_x, max_y, heightmap) do
    if MapSet.member?(set, point) do
      set
    else
      set
      |> MapSet.put(point)
      |> basin_neighbors(point, max_x, max_y, heightmap)
    end
  end

  defp basin_neighbors(set, point, max_x, max_y, heightmap) do
    height = heightmap[point]
    neighbors = neighbors(point, max_x, max_y)

    higher_neighbors =
      Enum.filter(neighbors, fn n ->
        n_height = heightmap[n]
        n_height != 9 and n_height > height
      end)

    Enum.reduce(higher_neighbors, set, fn n, set ->
      MapSet.union(set, basin(set, n, max_x, max_y, heightmap))
    end)
  end

  defp risk_level(point, heightmap) do
    height = heightmap[point]
    height + 1
  end

  defp low_point(point, max_x, max_y, heightmap) do
    height = heightmap[point]
    neighbors = neighbors(point, max_x, max_y)
    Enum.all?(neighbors, &(heightmap[&1] > height))
  end

  defp neighbors({x, y}, max_x, max_y) do
    x_neighbors(x, y, max_x) ++ y_neighbors(x, y, max_y)
  end

  defp x_neighbors(0, y, _max), do: [{1, y}]
  defp x_neighbors(max_x, y, max_x), do: [{max_x - 1, y}]
  defp x_neighbors(x, y, _max_x), do: [{x - 1, y}, {x + 1, y}]

  defp y_neighbors(x, 0, _max), do: [{x, 1}]
  defp y_neighbors(x, max_y, max_y), do: [{x, max_y - 1}]
  defp y_neighbors(x, y, _max_y), do: [{x, y - 1}, {x, y + 1}]
end
