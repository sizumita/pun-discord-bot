defmodule PunDiscordBot.Command do
  alias PunDiscordBot.Command
  @prefix "djr!"
  @bot_id 752040386104655922

  def handle(%{author: %{id: @bot_id}}), do: :noop

  def handle(msg = %{content: @prefix <> "parse " <> content}) do
    create_message msg.channel_id, "```\n#{Parser.get_yomi(content)}\n```"
  end

  def handle(msg = %{content: @prefix <> content}) do
    content
    |> String.trim()
    |> execute(msg)
  end

  def handle(msg) do
    pun = Pun.search msg.content
    if pun.surface != "" do
      create_message msg.channel_id, "だじゃれを検出しました！\n> **#{pun.surface}**"
    end
  end

  defp execute("ping", msg) do
    create_message msg.channel_id, "pong"
  end

  defp execute(_, msg) do
    create_message msg.channel_id, "This command doesnt exist, sorry"
  end

  defp create_message(channel_id, message) do
    Nostrum.Api.create_message(channel_id, message)
  end
end