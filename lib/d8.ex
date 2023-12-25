defmodule D8 do
  def ex_input(), do: "LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)"

  def ex_2(), do: "LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)"

  def readLines() do
    File.read!("priv/input/d8.txt") |> String.split(~r/\n\n/)
  end

  def p1 do
    [instructions, path] = readLines()
    path_map = path_maps(path)
    instructions = instructions |> String.codepoints()
    move(instructions, instructions, path_map, {"AAA", 0})
  end

  def p2 do
    [instructions, path] = readLines()
    path_map = path_maps(path)
    instructions = instructions |> String.codepoints()

    a_endings =
      Enum.reduce(path_map, [], fn {from, _to}, acc ->
        case Regex.match?(~r/A\b/, from) do
          true -> [from | acc]
          _ -> acc
        end
      end)

    Enum.map(a_endings, fn ghost ->
      move2(instructions, instructions, path_map, {ghost, 0})
    end)
    |> Enum.reduce(fn val, acc ->
      Math.lcm(val, acc)
    end)
  end

  defp path_maps(path) do
    path =
      path
      |> String.split("\n")
      |> Enum.map(&String.split(&1, " = "))
      |> Enum.map(fn path ->
        {from, to} = List.to_tuple(path)
        from = String.trim(from)
        to = String.trim(to, "(") |> String.trim(")") |> String.split(", ") |> List.to_tuple()
        {from, to}
      end)

    path
    |> Enum.reduce(
      %{},
      fn {from, to}, map ->
        Map.put(map, from, to)
      end
    )
  end

  defp move2(dir_traverse, dir, path, current_node)

  defp move2(_dir_current, _dir, _path_map, {<<_, _, ?Z>>, count}) do
    count
  end

  defp move2([], dir, path_map, current) do
    move2(dir, dir, path_map, current)
  end

  defp move2(["L" | t], dir, path, {current, count}) do
    {new, _} = Map.get(path, current)
    move2(t, dir, path, {new, count + 1})
  end

  defp move2(["R" | t], dir, path, {current, count}) do
    {_, new} = Map.get(path, current)
    move2(t, dir, path, {new, count + 1})
  end

  defp move(_instructions, _full_instructions, _path, {"ZZZ", count}) do
    count
  end

  defp move([], instructions, path, current) do
    move(instructions, instructions, path, current)
  end

  defp move(["L" | t], full_instructions, path, {current, count}) do
    {new, _} = Map.get(path, current)
    move(t, full_instructions, path, {new, count + 1})
  end

  defp move(["R" | t], full_instructions, path, {current, count}) do
    {_, new} = Map.get(path, current)
    move(t, full_instructions, path, {new, count + 1})
  end
end
