defmodule Mix.Tasks.Env.Setup do
  use Mix.Task

  @shortdoc "Initializes environment variables for the application."

  def run(_args) do
    Mix.shell().cmd("source init_env.sh", fn(output, _) ->
      IO.puts(output)
    end)
  end
end
