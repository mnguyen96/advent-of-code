defmodule Solution do
  @input_file "../../inputs/09.txt"

  defp part_1(input) do
    input = String.trim(input)
    map = parse(input)

    # IO.puts("Parsed map:")
    # IO.inspect(map, pretty: true, charlists: false)

    first = 0
    {last, _} = Enum.max(map)

    move_items_to_start(map, first, last)
    |> Enum.sort()
    |> Enum.flat_map(fn {_, {items, _}} -> items end)
    |> checksum()
  end

  defp parse(input) do
    input
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.map(fn {[size | rest], index} ->
      spaces = List.first(rest) || 0
      file_blocks = List.duplicate(index, size)
      {index, {file_blocks, spaces}}
    end)
    |> Map.new()
  end

  defp move_items_to_start(map, first, last) when last <= first, do: map

  defp move_items_to_start(map, first, last) do
    case map do
      %{^last => {items, _}} ->
        {map, first} =
          map
          |> Map.delete(last)
          |> insert_items_at_position(first, items, length(items))

        move_items_to_start(map, first, last - 1)
    end
  end

  defp insert_items_at_position(map, curr_pos, [], 0), do: {map, curr_pos}

  defp insert_items_at_position(map, curr_pos, items, count) do
    # IO.puts(curr_pos)

    case map do
      %{^curr_pos => {_, 0}} ->
        insert_items_at_position(map, curr_pos + 1, items, count)

      %{^curr_pos => {current, space}} ->
        can_fit = min(count, space)
        fits = Enum.take(items, space)
        rest = Enum.drop(items, space)
        new_space = space - can_fit
        new_count = count - can_fit
        new_map = Map.put(map, curr_pos, {current ++ fits, new_space})
        next_pos = if new_space == 0, do: curr_pos + 1, else: curr_pos
        insert_items_at_position(new_map, next_pos, rest, new_count)

      %{} ->
        {Map.put(map, curr_pos, {items, 0}), curr_pos}
    end
  end

  defp checksum(blocks) do
    blocks
    |> Stream.with_index()
    |> Enum.reduce(0, fn {file_id, position}, sum ->
      sum + file_id * position
    end)
  end

  defp test_1 do
    test_input = "2333133121414131402"
    IO.puts("\nTesting with input: #{test_input}")
    result = part_1(test_input)

    if result == 1928 do
      IO.puts("test 1: good")
    else
      IO.puts("test 1: bad (got #{result})")
    end

    result
  end

  def run do
    test_1()
    out = part_1(File.read!(@input_file))
    IO.puts("Result: #{out}")
  end
end

Solution.run()
