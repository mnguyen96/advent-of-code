defmodule Solution do
  @input_file "../../inputs/22.txt"

  defp part_1(input) do
    parse_input(input)
    |> Enum.map(fn secret ->
      secret
      |> Stream.iterate(&generate_sequence/1)
      |> Enum.at(2000)
    end)
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp generate_sequence(secret) do
    secret
    |> then(fn s ->
      s
      |> Kernel.*(64)
      |> mix(s)
      |> prune()
    end)
    |> then(fn s ->
      s
      |> Kernel.div(32)
      |> mix(s)
      |> prune()
    end)
    |> then(fn s ->
      s
      |> Kernel.*(2048)
      |> mix(s)
      |> prune()
    end)
  end

  defp mix(secret, value) do
    Bitwise.bxor(secret, value)
  end

  defp prune(secret) do
    rem(secret, 16_777_216)
  end

  defp part_2(input) do
    parse_input(input)
    |> Enum.reduce(%{}, fn secret, sales ->
      secret
      |> Stream.iterate(&generate_sequence/1)
      |> Stream.map(&rem(&1, 10))
      |> Stream.chunk_every(2, 1)
      |> Stream.map(fn [a, b] -> {b, b - a} end)
      |> Enum.take(2000)
      |> Enum.chunk_every(4, 1, :discard)
      |> Enum.flat_map(fn [_, _, _, {price, _}] = seq ->
        seq
        |> Enum.map(&elem(&1, 1))
        |> Enum.join()
        |> then(fn x -> [{x, price}] end)
      end)
      |> Enum.uniq_by(&elem(&1, 0))
      |> Enum.reduce(sales, fn {seq, price}, sales ->
        Map.update(sales, seq, price, &(&1 + price))
      end)
    end)
    |> Enum.max_by(fn {_, price} -> price end)
    |> elem(1)
  end

  defp test_1 do
    test_input = "
1
10
100
2024"

    IO.puts("Testing part 1...")
    IO.puts("Testing with input:\n#{test_input}")
    result = part_1(test_input)

    if result == 37_327_623 do
      IO.puts("test 1: good")
    else
      IO.puts("test 1: bad (got #{result})")
    end

    result
  end

  defp test_2 do
    test_input = "
1
2
3
2024"

    IO.puts("Testing part 2...")
    IO.puts("Testing with input:\n#{test_input}")
    result = part_2(test_input)

    if result == 23 do
      IO.puts("test 2: good")
    else
      IO.puts("test 2: bad (got #{result})")
    end

    result
  end

  def run do
    test_1()
    out1 = part_1(File.read!(@input_file))
    IO.puts("Part 1 Result: #{out1}")
    test_2()
    out2 = part_2(File.read!(@input_file))
    IO.puts("Part 2 Result: #{out2}")
  end
end

Solution.run()
