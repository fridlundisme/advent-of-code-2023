defmodule AdventOfCode.Year2023.Day9 do
  def ex_input(), do: "0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45"

  def readInput(input \\ :real) do
    input =
      case input do
        :real ->
          File.read!("priv/input/d9.txt")

        :ex ->
          ex_input()

        _ ->
          nil
      end

    String.split(input, "\n")
    |> Enum.map(fn line -> String.split(line) |> Enum.map(&String.to_integer/1) end)
  end

  def p1 do
    readInput(:real)
    |> Enum.map(&get_new_lines(&1))
    |> Enum.reduce(0, fn {_line, val}, acc -> val + acc end)
  end

  def p2 do
    readInput(:real)
    |> Enum.map(&get_new_lines2(&1))
    |> Enum.reduce(0, fn {_line, val}, acc -> val + acc end)
  end

  defp get_new_lines(line) do
    get_new_lines(line, {[], [line]})
    |> Enum.map_reduce(0, fn [h | _t], acc -> {h, h + acc} end)
  end

  defp get_new_lines2(line) do
    get_new_lines(line, {[], [line]})
    |> Enum.map(&Enum.reverse/1)
    |> Enum.map_reduce(0, fn [h | _t], acc -> {h, h - acc} end)
  end

  defp get_new_lines([_a | []], {current, total}) do
    case Enum.all?(current, &(&1 == 0)) do
      true ->
        {initial_history, rest} = List.pop_at(total, -1)
        initial_history = Enum.reverse(initial_history)

        [current | rest ++ [initial_history]]

      _ ->
        get_new_lines(current |> Enum.reverse(), {[], [current | total]})
    end
  end

  defp get_new_lines([a, b | rest], {current, total}) do
    diff = b - a
    acc = [diff | current]
    get_new_lines([b | rest], {acc, total})
  end
end
