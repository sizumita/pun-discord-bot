defmodule PunDiscordBotTest do
  use ExUnit.Case
  doctest PunDiscordBot

  test "greets the world" do
    assert PunDiscordBot.hello() == :world
  end
end
