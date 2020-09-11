defmodule Parser do
  def get_parsed_words parsed_text, true do
    Range.new(0, Enum.count(parsed_text)-1) |>
      Enum.map(fn at ->
        word = Enum.at parsed_text, at
        %{
          :yomi => conversion_characters(
                    if word["pronunciation"] == "",
                     do: conversion_characters(
                        if word["yomi"] == "",
                          do: word["surface_form"],
                          else: word["yomi"]),
                     else: word["pronunciation"]),
          :surface => word["surface_form"],
          :part => word["part_of_speech"],
          :at => at
        }
      end) |> filter_words
  end

  def get_parsed_words parsed_text, false do
    Range.new(0, Enum.count(parsed_text)-1) |>
      Enum.map(fn at ->
        word = Enum.at parsed_text, at
        %{
          :yomi => conversion_characters(
                   if word["yomi"] == "",
                     do: word["surface_form"],
                     else: word["yomi"]),
          :surface => word["surface_form"],
          :part => word["part_of_speech"],
          :at => at
        }
      end) |> filter_words
  end

  def filter_words words do
    words |> Enum.filter(fn(x) -> x.surface != "EOS" && x.part != "記号" && x.yomi != "" end)
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
      %{from: "「", to: ""},
      %{from: "」", to: ""},
      %{from: "(", to: ""},
      %{from: ")", to: ""},
      %{from: "（", to: ""},
      %{from: "）", to: ""},
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
