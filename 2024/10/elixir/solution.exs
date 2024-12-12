defmodule Solution do
  @input_file "../../inputs/10.txt"

  defp part_1(input) do
    grid = parse_input(input)
    trailheads = find_trailheads(grid)
    # IO.inspect(trailheads)

    trailheads
    |> Enum.map(fn trailhead ->
      MapSet.size(find_paths(grid, [{trailhead, MapSet.new([trailhead])}], MapSet.new()))
    end)
    |> Enum.sum()
  end

  defp part_2(input) do
    grid = parse_input(input)
    trailheads = find_trailheads(grid)

    trailheads
    |> Enum.map(fn trailhead ->
      length(count_paths(grid, [{trailhead, MapSet.new([trailhead])}], []))
    end)
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
  end

  defp get_dimensions(grid) do
    rows = length(grid)
    cols = length(Enum.at(grid, 0))
    {rows, cols}
  end

  defp find_trailheads(grid) do
    {rows, cols} = get_dimensions(grid)

    for r <- 0..(rows - 1),
        c <- 0..(cols - 1),
        Enum.at(Enum.at(grid, r), c) == 0,
        do: {r, c}
  end

  defp get_neighbors({row, col}, grid) do
    {rows, cols} = get_dimensions(grid)
    current_height = Enum.at(Enum.at(grid, row), col)
    target_height = current_height + 1

    [
      # up
      {row - 1, col},
      # down
      {row + 1, col},
      # left
      {row, col - 1},
      # right
      {row, col + 1}
    ]
    |> Enum.filter(fn {r, c} ->
      r >= 0 and r < rows and
        c >= 0 and c < cols and
        Enum.at(Enum.at(grid, r), c) == target_height
    end)
  end

  defp find_paths(_, [], reachable_nines), do: reachable_nines

  defp find_paths(grid, [{pos, visited} | rest], reachable_nines) do
    current_height = Enum.at(Enum.at(grid, elem(pos, 0)), elem(pos, 1))

    if current_height == 9 do
      # IO.inspect(rest)
      find_paths(grid, rest, MapSet.put(reachable_nines, pos))
    else
      next_positions = get_neighbors(pos, grid)

      new_paths =
        for pos <- next_positions,
            not MapSet.member?(visited, pos),
            do: {pos, MapSet.put(visited, pos)}

      # IO.inspect(rest)
      find_paths(grid, rest ++ new_paths, reachable_nines)
    end
  end

  defp count_paths(_, [], reachable_nines), do: reachable_nines

  defp count_paths(grid, [{pos, visited} | rest], reachable_nines) do
    current_height = Enum.at(Enum.at(grid, elem(pos, 0)), elem(pos, 1))

    if current_height == 9 do
      # IO.inspect(rest)
      count_paths(grid, rest, [pos | reachable_nines])
    else
      next_positions = get_neighbors(pos, grid)

      new_paths =
        for pos <- next_positions,
            do: {pos, MapSet.put(visited, pos)}

      # IO.inspect(rest)
      count_paths(grid, rest ++ new_paths, reachable_nines)
    end
  end

  defp test_1 do
    test_input = "89010123\n78121874\n87430965\n96549874\n45678903\n32019012\n01329801\n10456732"
    IO.puts("\nTesting with input: #{test_input}")
    result = part_1(test_input)

    if result == 36 do
      IO.puts("test 1: good")
    else
      IO.puts("test 1: bad (got #{result})")
    end

    result
  end

  defp test_2 do
    test_input = "89010123\n78121874\n87430965\n96549874\n45678903\n32019012\n01329801\n10456732"
    IO.puts("\nTesting part 2 with input: #{test_input}")
    result = part_2(test_input)

    if result == 81 do
      IO.puts("test 2: good")
    else
      IO.puts("test 2: bad (got #{result})")
    end

    result
  end

  def run do
    test_1()
    test_2()
    out1 = part_1(File.read!(@input_file))
    IO.puts("Part 1 Result: #{out1}")
    # out2 = part_2(File.read!(@input_file))
    # IO.puts("Part 2 Result: #{out2}")
  end
end

Solution.run()
