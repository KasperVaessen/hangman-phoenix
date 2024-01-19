defmodule Hangman.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Hangman.Games` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        correct_word: "some correct_word",
        finished: true,
        guessed_letters: ["option1", "option2"],
        user: "some user"
      })
      |> Hangman.Games.create_game()

    game
  end
end
