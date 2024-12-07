defmodule Solution do
  @input_file "../../inputs/04.txt"

  @directions [
    # right
    {0, 1},
    # down
    {1, 0},
    # down-right
    {1, 1},
    # up-right
    {-1, 1},
    # left
    {0, -1},
    # up
    {-1, 0},
    # up-left
    {-1, -1},
    # down-left
    {1, -1}
  ]
  def part_1(input) do
    grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    rows = length(grid)
    cols = length(Enum.at(grid, 0))

    for row <- 0..(rows - 1),
        col <- 0..(cols - 1),
        direction <- @directions,
        reduce: 0 do
      acc -> acc + check_xmas(grid, row, col, direction, rows, cols)
    end
  end

  defp check_xmas(grid, row, col, {dr, dc}, rows, cols) do
    curr_char = get_char(grid, row, col)

    if curr_char == "X" and in_bounds?(row + 3 * dr, col + 3 * dc, rows, cols) do
      chars =
        for i <- 1..3 do
          get_char(grid, row + i * dr, col + i * dc)
        end

      if chars == ["M", "A", "S"] do
        1
      else
        0
      end
    else
      0
    end
  end

  defp get_char(grid, row, col) do
    grid |> Enum.at(row) |> Enum.at(col)
  end

  defp in_bounds?(row, col, rows, cols) do
    row >= 0 and row < rows and col >= 0 and col < cols
  end

  def part_2(input) do
    grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    rows = length(grid)
    cols = length(Enum.at(grid, 0))

    for row <- 0..(rows - 2), col <- 0..(cols - 2), get_char(grid, row, col) == "A", reduce: 0 do
      acc -> acc + is_mas_pattern?(grid, row, col)
    end
  end

  defp is_mas_pattern?(grid, row, col) do
    # MAS/MAS 
    # MAS/SAM 
    # SAM/MAS 
    # SAM/SAM 
    patterns = [
      check_diagonal_pair(grid, row, col, :forward, :forward),
      check_diagonal_pair(grid, row, col, :forward, :backward),
      check_diagonal_pair(grid, row, col, :backward, :forward),
      check_diagonal_pair(grid, row, col, :backward, :backward)
    ]

    if Enum.any?(patterns), do: 1, else: 0
  end

  defp check_diagonal_pair(grid, row, col, dir1, dir2) do
    d1 = check_diagonal_mas(grid, row, col, -1, -1, 1, 1, dir1)
    d2 = check_diagonal_mas(grid, row, col, -1, 1, 1, -1, dir2)

    d1 and d2
  end

  defp check_diagonal_mas(grid, row, col, dr1, dc1, dr2, dc2, direction) do
    case direction do
      :forward ->
        get_char(grid, row + dr1, col + dc1) == "M" and
          get_char(grid, row + dr2, col + dc2) == "S"

      :backward ->
        get_char(grid, row + dr1, col + dc1) == "S" and
          get_char(grid, row + dr2, col + dc2) == "M"
    end
  end

  def test_1 do
    test_input =
      """
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
      """
      |> String.trim()

    result = part_1(test_input)

    if result == 18 do
      IO.puts("test 1: good")
    else
      IO.puts("test 1: bad")
    end

    result
  end

  def test_2 do
    test_input =
      """
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
      """
      |> String.trim()

    result = part_2(test_input)

    if result == 9 do
      IO.puts("test 2: good")
    else
      IO.puts("test 2: bad")
    end

    result
  end

  def run do
    out = Solution.part_1(File.read!(@input_file))
    IO.puts(out)

    Solution.test_1()

    out =
      Solution.part_2(File.read!("../../inputs/04.txt"))

    IO.puts(out)

    Solution.test_2()
  end
end

Solution.run()
