defmodule AdventOfCode.Year2023.Day3 do
  # Answer 550064
  def p1 do
    input =
      Enum.concat([
        [String.duplicate(".", 1)],
        File.read!("priv/input/d3.txt") |> String.split("\n"),
        [String.duplicate(".", 1)]
      ])

    chars =
      input
      |> Enum.map(&indicies(&1, :all))

    # format:
    # [{index, length, digit},...,{}]
    input
    |> Enum.map(&digit_indicies/1)
    |> Enum.with_index()
    # Ignore the first and last added row of dots
    |> Enum.drop(1)
    |> Enum.drop(-1)
    |> Enum.map(fn {digit, i} ->
      create_part_map(chars, digit, i)
    end)
    |> calculate_is_touching(:number)
    |> Enum.sum()
  end

  # answer: 85010461
  def p2 do
    input =
      Enum.concat([
        [String.duplicate(".", 1)],
        File.read!("lib/d3.txt") |> String.split("\n"),
        [String.duplicate(".", 1)]
      ])

    chars =
      input
      |> Enum.map(&indicies(&1, :gear))
      |> Enum.with_index()
      # Ignore the first and last added row of dots
      |> Enum.drop(1)
      |> Enum.drop(-1)

    # format:
    # [{index, length, digit},...,{}]
    digits =
      input
      |> Enum.map(&digit_indicies/1)
      |> Enum.with_index()

    Enum.map(chars, fn {map, i} ->
      case i do
        0 -> {0, %{}, {}}
        _ -> create_digit_map(digits, map, i)
      end
      |> calculate_is_touching(:gear)
      |> gear_ratio()
    end)
    |> Enum.sum()
  end

  def gear_ratio(list) do
    list
    |> Enum.reduce(0, fn gear, acc ->
      case length(gear) do
        2 ->
          Enum.reduce(gear, 1, fn {_touching, val}, acc -> val * acc end) + acc

        _ ->
          acc
      end
    end)
  end

  def create_digit_map(digits, map, i) do
    {d, _i} = Enum.at(digits, i - 1)
    {a, _i} = Enum.at(digits, i)
    {b, _i} = Enum.at(digits, i + 1)
    list = Enum.concat([d, a, b])
    {map, list}
  end

  def create_part_map(chars, digit, i) do
    d = Enum.at(chars, i - 1)
    a = Enum.at(chars, i)
    b = Enum.at(chars, i + 1)
    map = Map.merge(Map.merge(d, a), b)
    {digit, map}
  end

  def calculate_is_touching(digits, :number) do
    Enum.map(digits, fn {digits, map} ->
      Enum.map(digits, fn {index, len, digit} ->
        (index - 1)..(index + len)
        |> Range.to_list()
        |> Enum.flat_map(fn position ->
          case Map.has_key?(map, position) do
            true -> [{:touching, digit}]
            _ -> []
          end
        end)
      end)
      |> List.flatten()
      |> Enum.reduce(0, fn val, acc ->
        case val do
          {:touching, d} -> d + acc
          _ -> acc
        end
      end)
    end)
  end

  def calculate_is_touching({gears, digits}, :gear) do
    # Enum.map(gear_chars, fn {gears, digits} ->
    Enum.map(Map.keys(gears), fn key ->
      Enum.map(digits, fn {index, len, digit} ->
        digit_range = (index - 1)..(index + len)

        case Range.disjoint?(digit_range, key..key) do
          false -> {:touching, digit}
          _ -> {:not_touching}
        end
      end)
      |> Enum.filter(fn status ->
        case status do
          {:touching, _digit} ->
            true

          _ ->
            false
        end
      end)
    end)
  end

  def digit_indicies(row) do
    digits = Regex.scan(~r/[0-9]+/, row) |> List.flatten()

    Regex.scan(~r/[0-9]+/, row, return: :index)
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.map(fn {x, i} ->
      {digit, _} = List.pop_at(digits, i)
      Tuple.append(x, digit |> String.to_integer())
    end)
  end

  def indicies(row, :all) do
    char_indicies(row, ~r/[^A-Za-z0-9.]/)
  end

  def indicies(row, :gear) do
    char_indicies(row, ~r/[*]/)
  end

  def char_indicies(row, regex) do
    Regex.scan(regex, row, return: :index)
    |> List.flatten()
    |> Map.new()
  end
end
