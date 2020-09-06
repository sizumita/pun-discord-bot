defmodule PunDiscordBot.Consumer do
  use Nostrum.Consumer

  alias PunDiscordBot.Command
  alias Nostrum.Api

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    Command.handle(msg)
  end

  def handle_event(_event) do
    :noop
  end
end