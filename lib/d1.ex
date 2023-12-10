defmodule AOC do
  @moduledoc """
  Documentation for `AOC`.
  """

  defp readDay1 do
    File.read!("lib/d1_i.txt")
    |> String.split("\n")
  end

  def day1p1 do
    readDay1()
    |> Enum.map(&combine/1)
    |> Enum.reduce(fn x, acc -> x + acc end)
  end

  def combine(string) do
    digit1 =
      Regex.run(~r/\d{1}/, string, global: false) |> to_string()

    digit2 =
      Regex.run(~r/\d{1}/, String.reverse(string), global: false) |> to_string()

    (digit1 <> digit2) |> String.to_integer()
  end

  def day1p2 do
    d_map = %{
      "1" => 1,
      "one" => 1,
      "2" => 2,
      "two" => 2,
      "3" => 3,
      "three" => 3,
      "4" => 4,
      "four" => 4,
      "5" => 5,
      "five" => 5,
      "6" => 6,
      "six" => 6,
      "7" => 7,
      "seven" => 7,
      "8" => 8,
      "eight" => 8,
      "9" => 9,
      "nine" => 9
    }

    readDay1()
    |> Enum.map(fn string ->
      digits =
        Regex.scan(~r/(?=(one|two|three|four|five|six|seven|eight|nine|\d{1}))/, string)
        |> List.flatten()
        |> Enum.filter(&(&1 != ""))

      digit1 =
        Map.get(d_map, digits |> List.first(), 0)

      digit2 = Map.get(d_map, digits |> List.last(), 0)

      ((digit1 |> to_string) <> (digit2 |> to_string))
      |> String.to_integer()
    end)
    |> Enum.sum()
  end

  def hello do
    :world
  end
end
