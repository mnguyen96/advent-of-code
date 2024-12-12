defmodule Solution do
  @input_file "../../inputs/11.txt"

  defp solution(input, blinks) do
    parse_input(input)
    |> IO.inspect()
    |> evolve(blinks)
    |> length()
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp evolve(stones, 0), do: stones

  defp evolve(stones, blinks) do
    stones |> Enum.flat_map(&blink/1) |> evolve(blinks - 1)
  end

  defp blink(stone) do
    cond do
      stone == 0 ->
        [1]

      stone
      |> Integer.digits()
      |> length()
      |> rem(2) == 0 ->
        split(stone)

      true ->
        [stone * 2024]
    end
  end

  defp split(stone) do
    digits = Integer.digits(stone)
    mid = Integer.floor_div(length(digits), 2)

    [
      digits |> Enum.take(mid) |> Integer.undigits(),
      digits |> Enum.drop(mid) |> Integer.undigits()
    ]
  end

  defp test_1 do
    test_input = "125 17"
    IO.puts("\nTesting with input: #{test_input}")
    result = solution(test_input, 25)

    if result == 55312 do
      IO.puts("test 1: good")
    else
      IO.puts("test 1: bad (got #{result})")
    end

    result
  end

  def run do
    test_1()
    out1 = solution(File.read!(@input_file), 25)
    IO.puts("Part 1 Result: #{out1}")
    out2 = solution(File.read!(@input_file), 75)
    IO.puts("Part 2 Result: #{out2}")
  end
end

Solution.run()
