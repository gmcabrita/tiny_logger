defmodule TinyLogger do
  require Logger

  # Wrap all Logger level macros
  for func <- [:emergency, :alert, :critical, :error, :warning, :notice, :info, :debug] do
    def unquote(func)(data) when is_binary(data) do
      TinyLogger.unquote(func)(%{msg: data})
    end
    def unquote(func)(data) when is_map(data) do
      data = Process.get(:tinylogger_ctx, %{})
      |> Map.merge(data)

      Logger.unquote(func)(data)
    end

    args1 = Macro.generate_arguments(1, __MODULE__)
    def unquote(func)(data, unquote_splicing(args1)) when is_binary(data) do
      TinyLogger.unquote(func)(%{msg: data}, unquote_splicing(args1))
    end
    def unquote(func)(data, unquote_splicing(args1)) when is_map(data) do
      data = Process.get(:tinylogger_ctx, %{})
      |> Map.merge(data)

      Logger.unquote(func)(data, unquote_splicing(args1))
    end
  end

  # Allows you to do things like:
  # ```
  #   TinyLogger.with(%{user_id: 1}) do
  #     TinyLogger.with(%{team_id: 2}) do
  #       TinyLogger.info("Doing some work!!!")
  #     end
  #   end
  # ```
  #
  # The nested context is available in nested functions too.
  defmacro with(context, do: yield) do
    quote do
      old_context = Process.get(:tinylogger_ctx, %{})

      new_context = old_context
      |> Map.merge(unquote(context))

      Process.put(:tinylogger_ctx, new_context)
      unquote(yield)
      Process.put(:tinylogger_ctx, old_context)

      :ok
    end
  end
end
