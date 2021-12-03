defmodule AdventOfCode.Day3 do
  @behaviour AdventOfCode

  def setup(input) do
    nums =
      input
      |> String.split("\n")

    [first | _] = nums
    length = String.length(first)

    %{nums: nums, length: length}
  end

  def part1(%{nums: nums, length: length}) do
    gamma = most_common_bits(nums, length)
    epsilon = invert(gamma)

    to_decimal(gamma) * to_decimal(epsilon)
  end

  def part2(%{nums: nums, length: length}) do
    o2_rating = find_rating(nums, length, &most_common_bits(&1, length))
    co2_rating = find_rating(nums, length, &least_common_bits(&1, length))

    String.to_integer(o2_rating, 2) * String.to_integer(co2_rating, 2)
  end

  defp find_rating(nums, length, get_common_bits) do
    Enum.reduce_while(0..(length - 1), nums, fn i, nums ->
      common_bits = get_common_bits.(nums)
      target_bit = Enum.at(common_bits, i)

      possible_ratings =
        Enum.filter(nums, fn num ->
          String.at(num, i) == target_bit
        end)

      case possible_ratings do
        [result] -> {:halt, result}
        nums -> {:cont, nums}
      end
    end)
  end

  defp most_common_bits(nums, length) do
    for i <- 0..(length - 1) do
      most_common_bit(nums, i)
    end
  end

  defp least_common_bits(nums, length) do
    most_common_bits(nums, length) |> invert()
  end

  defp most_common_bit(nums, pos) do
    {zeros, ones} =
      Enum.reduce(nums, {0, 0}, fn n, {zeros, ones} ->
        case String.at(n, pos) do
          "0" -> {zeros + 1, ones}
          "1" -> {zeros, ones + 1}
        end
      end)

    cond do
      ones > zeros -> "1"
      zeros > ones -> "0"
      ones == zeros -> "1"
    end
  end

  defp invert(bits) do
    Enum.map(bits, fn
      "0" -> "1"
      "1" -> "0"
    end)
  end

  defp to_decimal(bits) do
    bits
    |> Enum.join()
    |> String.to_integer(2)
  end
end
