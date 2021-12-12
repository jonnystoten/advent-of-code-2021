defmodule AdventOfCode.Day8 do
  @behaviour AdventOfCode

  def setup(input) do
    entries =
      input
      |> String.split("\n")
      |> Enum.map(fn entry ->
        [patterns_str, output_str] = String.split(entry, " | ")
        patterns = String.split(patterns_str)
        output = String.split(output_str)
        {patterns, output}
      end)

    %{entries: entries}
  end

  def part1(%{entries: entries}) do
    entries
    |> Enum.map(fn {_patterns, output} ->
      Enum.count(output, fn o -> String.length(o) in [2, 3, 4, 7] end)
    end)
    |> Enum.sum()
  end

  def part2(%{entries: entries}) do
    entries
    |> Enum.map(fn {patterns, output} ->
      map = get_pattern_map(patterns)
      get_output_value(output, map)
    end)
    |> Enum.sum()
  end

  defp get_pattern_map(patterns) do
    one = Enum.find(patterns, fn p -> String.length(p) == 2 end)
    four = Enum.find(patterns, fn p -> String.length(p) == 4 end)
    seven = Enum.find(patterns, fn p -> String.length(p) == 3 end)
    eight = Enum.find(patterns, fn p -> String.length(p) == 7 end)

    five_chars = Enum.filter(patterns, fn p -> String.length(p) == 5 end)
    six_chars = Enum.filter(patterns, fn p -> String.length(p) == 6 end)

    {three, five_chars} = pattern_containing(five_chars, one)
    {nine, six_chars} = pattern_containing(six_chars, three)
    {zero, six_chars} = pattern_containing(six_chars, one)

    # last remaining 6 char pattern
    [six] = six_chars

    {[two], five_chars} =
      Enum.split_with(five_chars, fn p ->
        Enum.any?(String.graphemes(p), fn ch -> not String.contains?(nine, ch) end)
      end)

    # last remaining 5 char pattern
    [five] = five_chars

    %{
      zero => 0,
      one => 1,
      two => 2,
      three => 3,
      four => 4,
      five => 5,
      six => 6,
      seven => 7,
      eight => 8,
      nine => 9
    }
    |> Map.new(fn {k, v} ->
      {sort_pattern(k), v}
    end)
  end

  defp pattern_containing(patterns, target) do
    {[match], remaining} =
      Enum.split_with(patterns, fn p ->
        Enum.all?(String.graphemes(target), fn ch -> String.contains?(p, ch) end)
      end)

    {match, remaining}
  end

  defp get_output_value(output, pattern_map) do
    output
    |> Enum.map_join(fn o -> pattern_map[sort_pattern(o)] end)
    |> String.to_integer()
  end

  defp sort_pattern(pattern) do
    pattern |> String.graphemes() |> Enum.sort() |> Enum.join()
  end
end
