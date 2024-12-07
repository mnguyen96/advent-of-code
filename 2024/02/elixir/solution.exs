defmodule Solution do
  @input_file "../../inputs/02.txt"

  def part_1() do
    @input_file
    |> read_file()
    |> Enum.map(&parse_line/1)
    |> then(fn pairs ->
      left =
        pairs
        |> Enum.map(&elem(&1, 0))
        |> Enum.sort()

      right =
        pairs
        |> Enum.map(&elem(&1, 1))
        |> Enum.sort()

      Enum.zip(left, right)
    end)
    |> Enum.reduce(0, fn {left, right}, acc -> abs(left - right) + acc end)
  end

  def part_2() do
    pairs =
      @input_file
      |> read_file()
      |> Enum.map(&parse_line/1)

    right_count =
      pairs
      |> Enum.map(&elem(&1, 1))
      |> Enum.frequencies()

    pairs
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(0, fn val, acc ->
      acc + val * Map.get(right_count, val, 0)
    end)
  end

  defp read_file(file_name) do
    file_name
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  defp parse_line(row) do
    row
    |> String.split(" ", trim: true)
    |> then(fn [left, right] ->
      {
        String.to_integer(left),
        String.to_integer(right)
      }
    end)
  end
end

out = Solution.part_1()
IO.puts(out)

out = Solution.part_2()
IO.puts(out)
