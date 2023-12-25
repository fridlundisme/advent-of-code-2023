defmodule Mix.Tasks.Aoc.Solve do
  use Mix.Task

  @opts [
    aliases: [y: :year, d: :day, p: :part],
    strict: [year: :integer, day: :integer, part: :integer]
  ]
  def run(args) do
    {parsed, _argv, _err} = OptionParser.parse(args, @opts)

    with {:ok, func} <- get_function(parsed) do
      func.() |> then(IO.inspect(& &1))
    end
  end

  defp get_function(year: y, day: d, part: p) do
    AdventOfCode.Year2023.Day1
    module = Module.concat([AdventOfCode, "Year#{y}", "Day#{d}"])
    function = String.to_atom("p#{p}")

    with {:module, mod} <- Code.ensure_loaded(module),
         true <- function_exported?(mod, function, 0) do
      {:ok, Function.capture(mod, function, 0)}
    else
      {:error, _} ->
        Mix.shell()
        |> print_error("Module `#{inspect(module)}` is not defined.")

        :error

      false ->
        Mix.shell()
        |> print_error("Function `#{inspect(module)}.#{function}/1` is not defined.")

        :error
    end
  end

  defp print_error(shell, message) do
    tap(shell, & &1.error(message))
  end
end
