defmodule Solution do
  @input_file "../../inputs/23.txt"

  defp part_1(input) do
    map = parse_input(input)

    map
    |> Enum.flat_map(fn {a, bs} ->
      if String.starts_with?(a, "t") do
        bs
        |> Enum.flat_map(fn b ->
          map
          |> Map.get(b)
          |> Enum.flat_map(fn c ->
            if MapSet.member?(bs, c) do
              [MapSet.new([a, b, c])]
            else
              []
            end
          end)
        end)
      else
        []
      end
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp part_2(input) do
    map = parse_input(input)

    map
    |> Enum.map(fn {a, bs} ->
      bs
      |> Enum.map(fn b ->
        map |> Map.get(b) |> MapSet.intersection(bs)
      end)
      |> Enum.concat()
      |> Enum.reduce(MapSet.new([a]), fn node, group ->
        if MapSet.subset?(group, Map.get(map, node)) do
          MapSet.put(group, node)
        else
          group
        end
      end)
    end)
    # |> then(fn x ->
    #   IO.inspect(x)
    #   x
    # end)
    |> Enum.max_by(&MapSet.size/1)
    |> Enum.sort()
    |> Enum.join(",")
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-", trim: true))
    |> Enum.reduce(%{}, fn [a, b], map ->
      map
      |> Map.update(a, MapSet.new([b]), &MapSet.put(&1, b))
      |> Map.update(b, MapSet.new([a]), &MapSet.put(&1, a))
    end)
  end

  defp test_1 do
    test_input = "kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn"

    IO.puts("Testing part 1...")
    IO.puts("Testing with input:\n#{test_input}")
    result = part_1(test_input)

    if result == 7 do
      IO.puts("test 1: good")
    else
      IO.puts("test 1: bad (got #{result})")
    end

    result
  end

  defp test_2 do
    test_input = "kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn"

    IO.puts("Testing part 2...")
    IO.puts("Testing with input:\n#{test_input}")
    result = part_2(test_input)

    if result == "co,de,ka,ta" do
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
