defmodule AdventOfCode.Year2023.Day10 do
  def ex_input() do
    ".....
.S-7.
.|.|.
.L-J.
....."
  end

  def chart do
    [<<?|>>, <<?->>, <<?L>>, <<?J>>, <<?7>>, <<?F>>, <<?S>>]
  end

  defp chart_map() do
    %{
      <<?|>> => [<<?L>>, <<?J>>, <<?7>>, <<?F>>],
      <<?->> => [<<?L>>, <<?J>>, <<?7>>, <<?F>>],
      <<?L>> => [<<?->>, <<?|>>, <<?J>>, <<?7>>, <<?F>>],
      <<?J>> => [<<?->>, <<?|>>, <<?7>>, <<?F>>, <<?L>>],
      <<?7>> => [<<?->>, <<?|>>, <<?J>>, <<?F>>, <<?L>>],
      <<?S>> => [<<?->>, <<?|>>, <<?J>>, <<?F>>, <<?L>>, <<?7>>],
      <<?F>> => [<<?->>, <<?|>>, <<?J>>, <<?7>>, <<?L>>]
    }
  end

  def read_lines(input) do
    case input do
      :real ->
        File.read!("priv/input/d10.txt")

      :ex ->
        ex_input()

      _ ->
        nil
    end
  end

  def p1 do
    lines =
      read_lines(:ex)
      |> String.split("\n")
      |> Enum.with_index()

    start_node = get_start_node(lines)
    IO.inspect(start_node)

    Enum.reduce(lines, %{}, fn {row, i}, map ->
      String.codepoints(row)
      |> Enum.with_index()
      |> Enum.reduce(map, fn {val, j}, acc ->
        cond do
          val in chart() ->
            Map.put_new(acc, {i, j}, val)

          true ->
            acc
        end
      end)
    end)
    |> get_path(start_node)

    Enum.map(
      [],
      fn {} ->
        nil
        fn [] -> "list" end
      end
    )
  end

  defp get_path(map, {i, j} = start_node) do
    next_node =
      Enum.reduce_while(
        [{i - 1, j}, {i + 1, j}, {i, j - 1}, {i, j + 1}],
        map,
        fn node, acc ->
          IO.inspect(node, label: "current node")

          case Map.fetch(acc, node) |> IO.inspect(label: "val") do
            {:ok, val} ->
              val = Map.fetch!(chart_map(), val) |> IO.inspect(label: "fetch list")
              {:halt, val}

            :error ->
              {:cont, map}
          end
        end
      )
  end

  defp get_start_node(lines) do
    Enum.reduce_while(lines, {0, 0}, fn {row, i}, node ->
      row =
        row
        |> String.codepoints()
        |> Enum.with_index()

      case acc =
             Enum.reduce_while(row, node, fn {val, j}, acc ->
               case val do
                 <<?S>> ->
                   {:halt, {i, j}}

                 _ ->
                   {:cont, acc}
               end
             end) do
        {0, 0} -> {:cont, acc}
        _ -> {:halt, acc}
      end
    end)
  end
end
