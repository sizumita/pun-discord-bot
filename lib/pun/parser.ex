defmodule Parser do
  def get_yomi(parsed_text) do
    (Enum.join Enum.map(parsed_text, fn x -> x["yomi"] end), "") |> conversion_characters
  end

  def conversion_characters(text) do
    conversion text, [
      %{from: "！", to: ""},
      %{from: "!", to: ""},
      %{from: ",", to: ""},
      %{from: "、", to: ""},
      %{from: "ー", to: ""},
      %{from: "？", to: ""},
      %{from: "?", to: ""},
      %{from: "ッ", to: ""},
      %{from: "ァ", to: "ア"},
      %{from: "ィ", to: "イ"},
      %{from: "ゥ", to: "ウ"},
      %{from: "ェ", to: "エ"},
      %{from: "ォ", to: "オ"},
      %{from: "ャ", to: "ヤ"},
      %{from: "ュ", to: "ユ"},
      %{from: "ョ", to: "ヨ"},
    ]
  end

  defp conversion(text, []) do
    text
  end

  defp conversion(text, char_list) do
    conversion (String.replace text, (hd char_list).from, (hd char_list).to), (tl char_list)
  end
end
