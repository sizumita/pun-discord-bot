defmodule PunDiscordBot.Command do
  alias PunDiscordBot.Command
  @prefix "djr!"
  @mention "<@752040386104655922> "
  @mention_nick "<@!#{Application.get_env(:nostrum, :bot_id)}> "

  def handle(msg = %{content: @prefix <> content}) do
    content
    |> String.trim()
    |> execute(msg)
  end

  def handle(msg = %{content: @mention <> content}) do
    content
    |> String.trim()
    |> execute(msg)
  end

  def handle(msg = %{content: @mention_nick <> content}) do
    content
    |> String.trim()
    |> execute(msg)
  end

  def handle(msg) do
    pun = Pun.search msg.content
    if !msg.author.bot && pun.surface != "" do
      create_message msg.channel_id, "だじゃれを検出しました！\n> **#{pun.surface}**"
    end
  end

  defp execute("ping", msg) do
    create_message msg.channel_id, "pong"
  end

  defp execute("invite", msg) do
    create_message msg.channel_id, "https://discord.com/api/oauth2/authorize?client_id=752040386104655922&permissions=0&scope=bot"
  end

  defp execute(_, msg) do
  end

  defp create_message(channel_id, message) do
    Nostrum.Api.create_message(channel_id, message)
  end
end