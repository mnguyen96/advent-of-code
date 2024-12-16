defmodule Solution do
  @input_file "../../inputs/16.txt"
  # E,S,W,N
  @directions [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
  @rotation_cost 1000
  @move_cost 1

  defmodule PriorityQueue do
    def new(), do: []

    def push(queue, item, f_score) do
      insert_sorted(queue, {item, f_score})
    end

    def pop([]), do: {nil, []}
    def pop([{item, _} | rest]), do: {item, rest}

    defp insert_sorted([], item), do: [item]

    defp insert_sorted([{_, f1} = head | tail] = queue, {_, f2} = item) do
      if f2 <= f1 do
        [item | queue]
      else
        [head | insert_sorted(tail, item)]
      end
    end
  end

  defp part_1(input) do
    grid = parse_grid(input)
    # IO.inspect(grid)
    {start, goal} = find_points(grid)
    initial_state = {start, 0, 0}

    queue =
      PriorityQueue.push(
        PriorityQueue.new(),
        initial_state,
        manhattan_distance(start, goal)
      )

    find_path(queue, MapSet.new(), grid, goal)
  end

  defp part_2(input) do
    grid = parse_grid(input)
    # IO.inspect(grid)
    {start, goal} = find_points(grid)

    min_cost = part_1(input)
  end

  defp parse_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, grid ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(grid, fn {char, x}, acc ->
        Map.put(acc, {y, x}, char)
      end)
    end)
  end

  defp manhattan_distance({y1, x1}, {y2, x2}) do
    abs(y2 - y1) + abs(x2 - x1)
  end

  defp find_points(grid) do
    start = Enum.find_value(grid, fn {pos, char} -> if char == "S", do: pos end)
    goal = Enum.find_value(grid, fn {pos, char} -> if char == "E", do: pos end)
    {start, goal}
  end

  defp find_path(queue, visited, grid, goal) do
    case PriorityQueue.pop(queue) do
      {current_state, rest_queue} ->
        {pos, _dir, total_cost} = current_state

        if pos == goal do
          # IO.inspect(queue)
          # IO.inspect(current_state)
          # IO.puts(length(queue))
          total_cost
        else
          next_states = get_next_states(current_state, grid)

          {new_queue, new_visited} =
            Enum.reduce(next_states, {rest_queue, visited}, fn
              {new_pos, new_dir, new_cost} = state, {q, v} ->
                new_total_cost = total_cost + new_cost
                new_state = {new_pos, new_dir, new_total_cost}

                if not MapSet.member?(v, state) do
                  f_score = new_total_cost + manhattan_distance(new_pos, goal)

                  {
                    PriorityQueue.push(
                      q,
                      new_state,
                      f_score
                    ),
                    MapSet.put(v, state)
                  }
                else
                  {q, v}
                end
            end)

          find_path(new_queue, new_visited, grid, goal)
        end
    end
  end

  defp get_next_states({pos, dir, _cost}, grid) do
    # forward, turn left, turn right
    # {{y,x},direction, cost}
    [
      get_forward_state(pos, dir),
      get_rotation_state(pos, dir, -1),
      get_rotation_state(pos, dir, 1)
    ]
    |> Enum.filter(fn {new_pos, _dir, _cost} ->
      valid_position?(new_pos, grid)
    end)
  end

  defp get_forward_state({y, x}, dir) do
    {dy, dx} = Enum.at(@directions, dir)
    {{y + dy, x + dx}, dir, @move_cost}
  end

  defp get_rotation_state(pos, dir, rotation) do
    new_dir = Integer.mod(dir + rotation, 4)
    {pos, new_dir, @rotation_cost}
  end

  defp valid_position?(pos, grid) do
    case Map.get(grid, pos) do
      nil -> false
      "#" -> false
      _ -> true
    end
  end

  defp test_1 do
    test_input =
      "###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############
"

    IO.puts("Testing part 1...")
    IO.puts("Testing with input:\n#{test_input}")
    result = part_1(test_input)

    if result == 7036 do
      IO.puts("test 1: good")
    else
      IO.puts("test 1: bad (got #{result})")
    end

    result
  end

  defp test_2 do
    test_input =
      "###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############
"

    IO.puts("\nTesting part 2...")
    IO.puts("Testing with input:\n#{test_input}")
    result = part_2(test_input)

    if result == 45 do
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
    # out2 = part_2(File.read!(@input_file))
    # IO.puts("Part 2 Result: #{out2}")
  end
end

Solution.run()
