defmodule AdventOfCode.Year2023.Day11 do
  def ex_input do
    "...#......
    .......#..
    #.........
    ..........
    ......#...
    .#........
    .........#
    ..........
    .......#..
    #...#....."
  end

  def read_lines(input) do
    case input do
      :real ->
        File.read!("priv/input/d11.txt")

      :ex ->
        ex_input()

      _ ->
        nil
    end
  end

  def p1 do
    read_lines(:real)
    |> String.split()
    |> expand()
    |> Enum.with_index(1)
    |> Enum.flat_map(fn {row, i} ->
      String.codepoints(row)
      |> Enum.with_index(1)
      |> Enum.reduce([], fn {val, j}, acc ->
        cond do
          Regex.match?(~r/\#/, val) ->
            [{i, j} | acc]

          true ->
            acc
        end
      end)
    end)
    |> calc_dist(0)
  end

  defp expand(list) do
    list =
      Enum.map(list, fn row ->
        if row |> String.codepoints() |> Enum.all?(&(&1 == ".")) do
          [row, row]
        else
          row
        end
      end)
      |> List.flatten()

    duplicate_cols =
      Enum.map(list, fn row ->
        row
        |> String.codepoints()
        |> Enum.with_index()
        |> get_dots()
      end)
      |> Enum.reduce(fn row, acc ->
        for x <- row, y <- acc, x == y do
          x
        end
      end)

    Enum.reduce(duplicate_cols, list, fn col, acc ->
      Enum.map(acc, fn row -> String.codepoints(row) |> List.insert_at(col, ".") |> to_string end)
    end)
  end

  defp get_dots(row, acc \\ [])

  defp get_dots([], acc) do
    acc
  end

  defp get_dots([{val, index} | t], acc) do
    if val == "." do
      get_dots(t, [index | acc])
    else
      get_dots(t, acc)
    end
  end

  defp calc_dist([], sum) do
    sum
  end

  defp calc_dist([h | t], acc) do
    sum =
      Enum.reduce(t, 0, fn gx, acc ->
        acc + distance(h, gx)
      end)

    calc_dist(t, sum + acc)
  end

  defp distance({a_i, a_j}, {b_i, b_j}) do
    abs(b_i - a_i) + abs(b_j - a_j)
  end
end
