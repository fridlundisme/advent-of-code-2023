defmodule D2 do
  def readLines do
    File.read!("lib/d2.txt") |> String.split("\n")
  end

  # Answer: 2879
  def p1 do
    readLines()
    |> Enum.map(&extract/1)
    |> Enum.reduce(0, fn {game_id, val}, acc ->
      cond do
        val != :disqualified && val <= 39 -> acc + game_id
        true -> acc
      end
    end)
  end

  # Answer: 65122
  def p2 do
    readLines() |> Enum.map(&extract_p2/1) |> Enum.sum()
  end

  def extract_p2(line) do
    [_game, rest] = String.split(line, ":")

    String.split(rest, ";")
    |> Enum.map(&String.split(&1, ","))
    |> Enum.flat_map(fn sets ->
      Enum.map(
        sets,
        fn x -> String.trim(x) |> String.split() |> convert_hand end
      )
    end)
    |> max_values
    |> calculate_power
  end

  def calculate_power(values) do
    values |> Enum.reduce(1, fn {val, _color}, acc -> val * acc end)
  end

  def max_values(set) do
    Enum.group_by(set, fn {_, color} -> color end)
    |> Enum.map(fn {_color, tuples} ->
      Enum.max_by(tuples, fn {val, _color} -> val end)
    end)
  end

  def extract(line) do
    [game, rest] = String.split(line, ":")

    game = {String.split(game) |> List.last() |> String.to_integer()}

    Tuple.append(
      game,
      String.split(rest, ";")
      |> Enum.map(&String.split(&1, ","))
      |> Enum.flat_map(fn x ->
        rules(x)
        |> remove_rulebreakers()
      end)
      |> Enum.max(fn -> :disqualified end)
    )
  end

  def remove_rulebreakers(ruled) do
    case Enum.reduce(ruled, true, fn y, acc ->
           {_, inRange, _} = y
           acc && inRange
         end) do
      true ->
        [ruled |> Enum.reduce(0, fn {_, _, val}, acc -> val + acc end)]

      _ ->
        [:disqualified]
    end
  end

  def rules(sets) do
    Enum.map(
      sets,
      fn x -> String.trim(x) |> String.split() |> convert_hand |> verify end
    )
  end

  def convert_hand(hand) do
    Enum.map(hand, fn x ->
      try do
        String.to_integer(x)
      rescue
        _ -> x
      end
    end)
    |> List.to_tuple()
  end

  def verify({value, "red"}) when value > 12 do
    {:red, false, value}
  end

  def verify({value, "red"}) do
    {:red, true, value}
  end

  def verify({value, "green"}) when value > 13 do
    {:green, false, value}
  end

  def verify({value, "green"}) do
    {:green, true, value}
  end

  def verify({value, "blue"}) when value > 14 do
    {:blue, false, value}
  end

  def verify({value, "blue"}) do
    {:blue, true, value}
  end
end
