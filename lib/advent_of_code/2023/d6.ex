defmodule AdventOfCode.Year2023.Day6 do
  defp readlines() do
    File.read!("priv/input/d6.txt") |> String.split(~r/(\n\n)/)
  end

  def p1 do
    [fst, st, tt, ft, fsd, sd, td, fd] =
      readlines()
      |> Enum.flat_map(
        &(Regex.scan(~r/[0-9]+/, &1)
          |> List.flatten()
          |> Enum.flat_map(fn val -> [String.to_integer(val)] end))
      )

    first = {:first, {fst, fsd}}
    second = {:second, {st, sd}}
    third = {:third, {tt, td}}
    fourth = {:third, {ft, fd}}
    IO.inspect({first, second, third, fourth})

    races = [first, second, third, fourth]

    Enum.map(races, fn {_race, {time, record}} ->
      calculate_roots(time, record)
    end)
    |> Enum.map(fn {from, to} -> Range.new(from, to) |> Range.size() end)
    |> Enum.reduce(fn range, acc -> range * acc end)
  end

  defp calculate_roots(time, record) do
    {root1, root2} = roots(1, time, record)
    IO.inspect({root1, root2}, label: "roots")

    root1 = root1 - 1
    root2 = root2 + 1
    {r1, _} = -Float.ceil(root1) |> Float.ratio()
    {r2, _} = -Float.floor(root2) |> Float.ratio()
    {r1, r2}
  end

  def p2 do
    {time, dist} =
      readlines()
      |> Enum.flat_map(
        &(Regex.scan(~r/[0-9]+/, &1)
          |> List.flatten()
          |> Enum.flat_map(fn val -> [val] end))
      )
      |> Enum.chunk_every(4)
      |> Enum.map(fn list ->
        Enum.reduce(list, fn val, acc -> acc <> val end) |> String.to_integer()
      end)
      |> List.to_tuple()

    {r1, r2} = calculate_roots(time, dist)
    Range.new(r1, r2) |> Range.size()
  end

  def roots(a, b, c) do
    IO.puts("Roots of a quadratic function (#{a}, #{b}, #{c})")
    d = b * b - 4 * a * c
    a2 = a * 2

    cond do
      d > 0 ->
        sd = :math.sqrt(d)
        {(-b + sd) / a2, (-b - sd) / a2}

      d == 0 ->
        -b / a2
    end
  end
end
