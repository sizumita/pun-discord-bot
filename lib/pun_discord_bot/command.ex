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
    if !msg.author.bot do
      lhs = Pun.search(msg.content)
      rhs = Pun.search(msg.content, true)
      case {lhs.surface, rhs.surface} do
        {"", ""} -> :ignore
        {lhs_surface, ""} -> create_message msg.channel_id, "だじゃれを検出しました！\n> **#{lhs_surface}**\n > **#{lhs.checked_surface}**"
        {"", rhs_surface} -> create_message msg.channel_id, "だじゃれを検出しました！\n> **#{rhs_surface}**\n > **#{rhs.checked_surface}**"
        {lhs_surface, rhs_surface} ->
          if String.length(lhs_surface) > String.length(rhs_surface) do
            create_message msg.channel_id, "だじゃれを検出しました！\n> **#{lhs_surface}**\n > **#{lhs.checked_surface}**"
          else
            create_message msg.channel_id, "だじゃれを検出しました！\n> **#{rhs_surface}**\n > **#{rhs.checked_surface}**"
          end
      end
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