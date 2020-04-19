defmodule TinyLoggerTest do
  use ExUnit.Case
  doctest TinyLogger

  test "greets the world" do
    assert TinyLogger.hello() == :world
  end
end
