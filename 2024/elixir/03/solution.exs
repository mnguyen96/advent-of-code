defmodule Solution do
  @input_file "../../inputs/03.txt"

  def part_1(mem_input) do
    mem_input
    |> then(fn input -> Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, input) end)
    |> Enum.map(fn [_, x, y] ->
      String.to_integer(x) * String.to_integer(y)
    end)
    |> Enum.sum()
  end

  def part_2(mem_input) do
    mem_input
    |> then(fn input -> "do()" <> String.replace(input, "\n", "") <> "don't()" end)
    |> then(fn input -> Regex.scan(~r/do\(\).*?don't\(\)/, input) end)
    |> Enum.flat_map(fn input ->
      input |> Enum.map(&part_1/1)
    end)
    |> Enum.sum()
  end

  def test do
    test_input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

    result =
      part_2(test_input)

    if result == 48 do
      IO.puts("good")
    else
      IO.puts("bad")
    end

    result
  end
end

out = Solution.part_1(File.read!("../../inputs/03.txt"))
IO.puts(out)

out =
  Solution.part_2(File.read!("../../inputs/03.txt"))

IO.puts(out)
out = Solution.test()
IO.puts(out)
