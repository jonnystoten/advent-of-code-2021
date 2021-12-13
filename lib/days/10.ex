defmodule AdventOfCode.Day10 do
  @behaviour AdventOfCode

  def setup(input) do
    lines =
      input
      |> String.split("\n")

    %{lines: lines}
  end

  def part1(%{lines: lines}) do
    lines
    |> Enum.map(&parse_line/1)
    |> Enum.filter(&match?({:corrupt, _actual}, &1))
    |> Enum.map(fn {:corrupt, actual} -> syntax_score(actual) end)
    |> Enum.sum()
  end

  def part2(%{lines: lines}) do
    lines
    |> Enum.map(&parse_line/1)
    |> Enum.filter(&match?({:incomplete, _stack}, &1))
    |> Enum.map(fn {:incomplete, stack} -> autocomplete_score(stack) end)
    |> Enum.sort()
    |> middle()
  end

  defp middle([single]), do: single
  defp middle([_head | tail]), do: middle(Enum.reverse(tail))

  defp parse_line(line) do
    parse_line(String.graphemes(line), [])
  end

  defp parse_line([], []), do: :valid

  defp parse_line([], stack), do: {:incomplete, stack}

  defp parse_line([head | tail], stack) when head in ["(", "[", "{", "<"] do
    parse_line(tail, [matching(head) | stack])
  end

  defp parse_line([head | tail], [head | stack]) do
    parse_line(tail, stack)
  end

  defp parse_line([head | _tail], [_expected | _stack]) do
    {:corrupt, head}
  end

  defp matching("("), do: ")"
  defp matching("["), do: "]"
  defp matching("{"), do: "}"
  defp matching("<"), do: ">"

  defp syntax_score(")"), do: 3
  defp syntax_score("]"), do: 57
  defp syntax_score("}"), do: 1197
  defp syntax_score(">"), do: 25137

  defp autocomplete_score(stack) do
    Enum.reduce(stack, 0, fn ch, acc ->
      acc * 5 + autocomplete_char_score(ch)
    end)
  end

  defp autocomplete_char_score(")"), do: 1
  defp autocomplete_char_score("]"), do: 2
  defp autocomplete_char_score("}"), do: 3
  defp autocomplete_char_score(">"), do: 4
end
