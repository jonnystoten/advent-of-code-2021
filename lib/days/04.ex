defmodule AdventOfCode.Day4 do
  @behaviour AdventOfCode

  def setup(input) do
    [first, rest] = String.split(input, "\n\n", parts: 2)

    draws =
      first
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    boards =
      rest
      |> String.split("\n\n")
      |> Enum.map(&parse_board/1)

    %{boards: boards, draws: draws}
  end

  defp parse_board(str) do
    split =
      str
      |> String.split("\n")
      |> Enum.map(fn row ->
        row
        |> String.split(" ", trim: true)
        |> Enum.map(&String.trim/1)
      end)

    for x <- 0..4, y <- 0..4, into: %{} do
      row = Enum.at(split, y)
      char = Enum.at(row, x)
      num = String.to_integer(char)
      {{x, y}, {num, false}}
    end
  end

  def part1(%{boards: boards, draws: draws}) do
    {winner, draw} =
      Enum.reduce_while(draws, boards, fn draw, boards ->
        boards = mark_boards(boards, draw)

        case find_winning_boards(boards) do
          [winner] -> {:halt, {winner, draw}}
          _ -> {:cont, boards}
        end
      end)

    score_winner(winner, draw)
  end

  def part2(%{boards: boards, draws: draws}) do
    {winner, draw} =
      Enum.reduce_while(draws, boards, fn draw, boards ->
        boards = mark_boards(boards, draw)

        case find_winning_boards(boards) do
          ^boards = [last_board] ->
            {:halt, {last_board, draw}}

          winners ->
            {:cont, boards -- winners}
        end
      end)

    score_winner(winner, draw)
  end

  defp mark_boards(boards, draw) do
    Enum.map(boards, fn board ->
      Map.map(board, fn {_key, {num, marked}} ->
        {num, num == draw || marked}
      end)
    end)
  end

  defp find_winning_boards(boards) do
    Enum.filter(boards, &winner?/1)
  end

  defp winner?(board) do
    full_rows =
      Enum.reduce(0..4, MapSet.new(), fn i, full_rows ->
        full_rows
        |> MapSet.put("x#{i}")
        |> MapSet.put("y#{i}")
      end)

    full_rows =
      Enum.reduce(board, full_rows, fn {{x, y}, {_, marked}}, full_rows ->
        if marked do
          full_rows
        else
          full_rows
          |> MapSet.delete("x#{x}")
          |> MapSet.delete("y#{y}")
        end
      end)

    Enum.any?(full_rows)
  end

  defp score_winner(board, last_draw) do
    sum =
      Enum.reduce(board, 0, fn {{_x, _y}, {num, marked}}, sum ->
        if marked do
          sum
        else
          sum + num
        end
      end)

    sum * last_draw
  end
end
