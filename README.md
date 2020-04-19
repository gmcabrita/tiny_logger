# TinyLogger

Do not look at this monstrosity (though it might eventually turn into something useful).

## Example Usage

```elixir
defmodule Foo do
  require TinyLogger

  def bar(arg) do
    TinyLogger.with(%{bar_arg: arg}) do
      TinyLogger.info("Ran bar/1")
    end
  end

  def baz(arg) do
    TinyLogger.with(%{baz_arg: arg}) do
      bar(arg)
    end
  end
end
```

```elixir
iex(1)> Foo.baz(1)

00:03:22.808 [info]  [bar_arg: 1, baz_arg: 1, msg: "Ran bar/1"]
:ok
```