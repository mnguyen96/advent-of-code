defmodule Solution do
  @input_file "../../inputs/24.txt"

  defp part_1(input) do
    {wires, instructions} = parse_input(input)

    final_wires =
      compute(wires, instructions)

    final_wires
    |> Enum.filter(fn {wire, _} -> String.starts_with?(wire, "z") end)
    |> Enum.sort(:desc)
    |> Enum.map(fn {_, val} -> val end)
    |> Enum.join()
    |> Integer.parse(2)
    |> elem(0)
  end

  # defp part_2(input) do
  # end
  defp compute(wires, [{x, op, y, res} | rest]) do
    if Map.has_key?(wires, x) and Map.has_key?(wires, y) do
      x_val = Map.get(wires, x)
      y_val = Map.get(wires, y)

      result =
        case op do
          "AND" -> if(x_val == 1 and y_val == 1, do: 1, else: 0)
          "OR" -> if(x_val == 1 or y_val == 1, do: 1, else: 0)
          "XOR" -> Bitwise.bxor(x_val, y_val)
        end

      compute(Map.put(wires, res, result), rest)
    else
      compute(wires, rest ++ [{x, op, y, res}])
    end
  end

  defp compute(wires, []) do
    wires
  end

  defp parse_input(input) do
    [sec1, sec2] =
      input
      |> String.split("\n\n", trim: true)

    wires =
      sec1
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ": ", trim: true))
      |> Enum.reduce(%{}, fn [a, b], map ->
        Map.put(map, a, String.to_integer(b))
      end)

    instructions =
      sec2
      |> String.split("\n", trim: true)
      |> Enum.map(fn x ->
        [w1, op, w2, _, res] = String.split(x, " ", trim: true)
        {w1, op, w2, res}
      end)

    {wires, instructions}
  end

  defp test_input() do
    "x00: 1
x01: 0
x02: 1
x03: 1
x04: 0
y00: 1
y01: 1
y02: 1
y03: 1
y04: 1

ntg XOR fgs -> mjb
y02 OR x01 -> tnw
kwq OR kpj -> z05
x00 OR x03 -> fst
tgd XOR rvg -> z01
vdt OR tnw -> bfw
bfw AND frj -> z10
ffh OR nrd -> bqk
y00 AND y03 -> djm
y03 OR y00 -> psh
bqk OR frj -> z08
tnw OR fst -> frj
gnj AND tgd -> z11
bfw XOR mjb -> z00
x03 OR x00 -> vdt
gnj AND wpb -> z02
x04 AND y00 -> kjc
djm OR pbm -> qhw
nrd AND vdt -> hwm
kjc AND fst -> rvg
y04 OR y02 -> fgs
y01 AND x02 -> pbm
ntg OR kjc -> kwq
psh XOR fgs -> tgd
qhw XOR tgd -> z09
pbm OR djm -> kpj
x03 XOR y03 -> ffh
x00 XOR y04 -> ntg
bfw OR bqk -> z06
nrd XOR fgs -> wpb
frj XOR qhw -> z04
bqk OR frj -> z07
y03 OR x01 -> nrd
hwm AND bqk -> z03
tgd XOR rvg -> z12
tnw OR pbm -> gnj"
  end

  defp test_1 do
    test_input = test_input()
    IO.puts("Testing part 1...")
    # IO.puts("Testing with input:\n#{test_input}")
    result = part_1(test_input)

    if result == 2024 do
      IO.puts("test 1: good")
    else
      IO.puts("test 1: bad (got #{result})")
    end

    result
  end

  # defp test_2 do
  #   test_input = test_input()
  #
  #   IO.puts("Testing part 2...")
  #   # IO.puts("Testing with input:\n#{test_input}")
  #   result = part_2(test_input)
  #
  #   if result == "co,de,ka,ta" do
  #     IO.puts("test 2: good")
  #   else
  #     IO.puts("test 2: bad (got #{result})")
  #   end
  #
  #   result
  # end

  def run do
    test_1()
    out1 = part_1(File.read!(@input_file))
    IO.puts("Part 1 Result: #{out1}")
    # test_2()
    # out2 = part_2(File.read!(@input_file))
    # IO.puts("Part 2 Result: #{out2}")
  end
end

Solution.run()
