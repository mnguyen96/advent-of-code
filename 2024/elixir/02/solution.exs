defmodule Solution do
  @input_file "../../inputs/02.txt"

  def part_1() do
    @input_file
    |> read_file()
    |> Enum.map(&parse_line/1)
    |> Enum.filter(&is_safe/1)
    |> length()
  end

  def part_2() do
  end

  defp read_file(file_name) do
    file_name
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  defp parse_line(row) do
    Enum.map(String.split(row, " "), &String.to_integer/1)
  end

  defp is_safe([a, b | _] = report) when a < b, do: is_safe(report, :asc)
  defp is_safe([a, b | _] = report) when a > b, do: is_safe(report, :desc)
  defp is_safe([a, b | _]), do: false

  defp is_safe([a, b | rest], :asc) when abs(a - b) in 1..3 and a < b,
    do: is_safe([b | rest], :asc)

  defp is_safe([a, b | rest], :desc) when abs(a - b) in 1..3 and a > b,
    do: is_safe([b | rest], :desc)

  defp is_safe([_last], _), do: true
  defp is_safe(_, _), do: false
end

out = Solution.part_1()
IO.puts(out)

out = Solution.part_2()
IO.puts(out)
