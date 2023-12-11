defmodule MapUpdater do
  def increment_map(map, {a, b}) do
    Enum.reduce(b..(b + a), map, fn index, acc ->
      Map.update(acc, index, 1, &(&1 + 1))
    end)
  end

  def update_map_from_list(list) do
    Enum.reduce(list, %{}, &increment_map(&2, &1))
  end
end

list = [{4, 0}, {2, 1}, {2, 2}, {1, 3}, {0, 4}, {0, 5}]
MapUpdater.update_map_from_list(list)
