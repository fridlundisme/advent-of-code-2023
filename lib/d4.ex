defmodule D4 do
  import Bitwise

  defp read_lines do
    File.read!("priv/input/d4.txt") |> String.split("\n")
  end

  # Answer: 2879
  def p1 do
    read_lines()
    |> Enum.map(&winning_number_count/1)
    |> Enum.map(&(1 <<< (&1 - 1)))
    |> Enum.sum()
  end

  def p2 do
    read_lines()
    |> Enum.map(&winning_number_count/1)
    |> Enum.with_index()
    |> add_count()
    |> Enum.map(fn {_key, val} -> val end)
    |> Enum.sum()
  end

  def add_count(v) do
    Enum.reduce(v, %{}, fn {winning_tickets, i}, map ->
      map = Map.update(map, i, 1, &(&1 + 1))

      case winning_tickets do
        0 ->
          map

        _ ->
          range = (i + 1)..(i + winning_tickets)

          Enum.reduce(range, map, fn j, acc ->
            Map.update(acc, j, map[i], &(&1 + map[i]))
          end)
      end
    end)
  end

  def winning_number_count(row) do
    winning_numbers = Enum.at(read_row(row), 0)
    my_numbers = Enum.at(read_row(row), 1)

    Enum.map(winning_numbers, fn number ->
      Enum.find(my_numbers, &(&1 == number))
    end)
    |> Enum.filter(&is_integer/1)
    |> Enum.count()
  end

  def read_row(row) do
    [_h | t] = row |> String.split(":")

    t
    |> Enum.flat_map(fn x ->
      String.split(x, "|")
      |> Enum.map(fn y -> String.split(y) |> Enum.map(&String.to_integer/1) end)
    end)
  end
end
