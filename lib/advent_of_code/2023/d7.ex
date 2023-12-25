defmodule AdventOfCode.Year2023.Day7 do
  def ex_input, do: "32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483"

  def readInput do
    File.read!("priv/input/d7.txt")
  end

  def p1 do
    hands_ = %{
      :pair => {~r/AA|KK|QQ|JJ|TT|22|33|44|55|66|77|88|99/, 2},
      :three => {~r/AAA|KKK|QQQ|JJJ|TTT|222|333|444|555|666|777|888|999/, 3},
      :four => {~r/AAAA|KKKK|QQQQ|JJJJ|TTTT|2222|3333|4444|5555|6666|7777|8888|9999/, 4},
      :five =>
        {~r/AAAAA|KKKKK|QQQQQ|JJJJJ|TTTTT|22222|33333|44444|55555|66666|77777|88888|99999/, 5}
    }

    hands_point = %{
      :one => 1,
      :pair => 1.5,
      :two_pair => 2,
      :triss => 3,
      :full => 3.5,
      :four => 4,
      :five => 5
    }

    card_values = %{
      "A" => 13,
      "K" => 12,
      "Q" => 11,
      "J" => 10,
      "T" => 9,
      "9" => 8,
      "8" => 7,
      "7" => 6,
      "6" => 5,
      "5" => 4,
      "4" => 3,
      "3" => 2,
      "2" => 1
    }

    readInput()
    |> String.split("\n")
    |> Enum.map(fn line ->
      {sorted_hand, hand, bid} = sorted_hand(line)

      hands =
        Enum.flat_map(hands_, fn {key, {regex, _score}} ->
          case scanned = Regex.scan(regex, sorted_hand) do
            [] -> [{:one, [], {hand, bid}}]
            _ -> [{key, scanned |> List.flatten(), {hand, bid}}]
          end
        end)

      calculate_hand(hands)
      |> List.flatten()
      |> IO.inspect(label: "hands")
      |> get_best_hand(hands_point)
    end)
    |> sort_cards(card_values)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, _, {_, bid}, _}, rank}, acc -> bid * rank + acc end)
  end

  defp sort_cards(hands, card_values) do
    hands
    |> Enum.sort(fn a, b ->
      {_name, _list, __hand, a_value} = a
      {_name, _list, __hand, b_value} = b

      cond do
        a_value < b_value ->
          true

        a_value == b_value ->
          compare_cards(a, b, card_values)

        true ->
          false
      end
    end)
  end

  defp sorted_hand(line) do
    {hand, bid} =
      String.split(line)
      |> List.to_tuple()

    {hand, bid} = {hand, bid |> String.to_integer()}

    sorted_hand =
      String.codepoints(hand) |> Enum.sort() |> List.to_string()

    {sorted_hand, hand, bid}
  end

  defp compare_cards({_, _, {a_hand, _bid}, _}, {_, _, {b_hand, _bid_b}, _}, card_values) do
    compare_cards(a_hand |> String.codepoints(), b_hand |> String.codepoints(), card_values)
  end

  defp compare_cards([a_h | a_t], [b_h | b_t], map) do
    a_val = Map.get(map, a_h)
    b_val = Map.get(map, b_h)

    case a_val == b_val do
      false -> a_val < b_val
      _ -> compare_cards(a_t, b_t, map)
    end
  end

  defp get_best_hand(hands, points) do
    best_hand =
      hands
      |> Enum.reduce(fn a = {key, _a_pt, _hand}, acc ->
        {b_key, _b_pt, _} = acc
        a_pt = Map.get(points, key)
        b_pt = Map.get(points, b_key)

        case b_pt > a_pt do
          true -> acc
          _ -> a
        end
      end)

    best_hand =
      case best_hand do
        {:triss, [h1], v} ->
          case Enum.find(hands, fn x ->
                 case x do
                   {:pair, [h2], _} ->
                     not String.contains?(h1, h2)

                   _ ->
                     false
                 end
               end) do
            nil -> best_hand
            _ -> {:full, [h1], v}
          end

        _ ->
          best_hand
      end

    {hand, _, _} = best_hand
    Tuple.append(best_hand, Map.get(points, hand))
  end

  defp calculate_hand([]), do: []

  defp calculate_hand([{:pair, li, hand} | t]) when length(li) > 1 do
    pairs = Enum.map(li, fn v -> {:pair, v, hand} end)

    [{:two_pair, li, hand}, calculate_hand(pairs), calculate_hand(t)]
  end

  defp calculate_hand([{:pair, li, hand} | t]) do
    [{:pair, [li] |> List.flatten(), hand}, calculate_hand(t)]
  end

  defp calculate_hand([{:three, li, hand} | t]) when length(li) > 1 do
    [{:full, li, hand}, calculate_hand(t)]
  end

  defp calculate_hand([{:three, li, hand} | t]) do
    [{:triss, li, hand}, calculate_hand(t)]
  end

  defp calculate_hand([h | t]) do
    [h, calculate_hand(t)]
  end
end
