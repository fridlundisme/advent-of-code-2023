defmodule D5 do
  defp readlines() do
    File.read!("priv/input/d5.txt") |> String.split(~r/(\n\n)/)
  end

  def p1 do
    {seeds, list} = init()
    IO.inspect(seeds)

    Enum.map(seeds, &recur(&1, list)) |> Enum.min() |> IO.inspect(label: "res")
  end

  def measure_execution_time do
    {time, result} = :timer.tc(D5, :p2, [], :second)
    IO.puts("Execution time: #{time} sec")
    result
  end

  def p2 do
    {seeds, list} = init()

    ranges =
      Enum.chunk_every(seeds, 2)
      |> Enum.map(fn [h, t] -> Range.new(h, h + t - 1) end)

    Enum.map(ranges, fn seed ->
      Enum.flat_map(Enum.at(list, 0), fn {_diff, dest, source} ->
        case Range.disjoint?(seed, source) do
          false ->
            [{seed, source, dest}]

          _ ->
            []
        end
      end)
    end)

    # Enum.map(ranges, &recur(&1, list)) |> Enum.min() |> IO.inspect(label: "res")
  end

  defp init() do
    {seeds, seed_soil, soil_fert, fert_wat, wat_light, light_temp, temp_hum, hum_loc} =
      readlines()
      |> Enum.map(
        &(Regex.scan(~r/[0-9]+/, &1)
          |> List.flatten()
          |> Enum.map(fn val -> String.to_integer(val) end))
      )
      |> List.to_tuple()

    list =
      Enum.map(
        [seed_soil, soil_fert, fert_wat, wat_light, light_temp, temp_hum, hum_loc],
        fn map ->
          Enum.chunk_every(map, 3) |> map_to_ranges()
        end
      )

    {seeds, list}
  end

  defp recur(val, []) do
    val
  end

  defp recur(val, [h | t]) do
    Enum.reduce_while(h, val, fn {{_atom, diff}, dest, source}, acc ->
      case acc in source do
        true -> {:halt, acc + diff}
        _ -> {:cont, acc}
      end
    end)
    |> recur(t)
  end

  defp map_to_ranges(map) do
    Enum.map(map, fn [dest, source, len] ->
      {{:diff, dest - source}, Range.new(dest, dest + len - 1),
       Range.new(source, source + len - 1)}
    end)
  end
end
