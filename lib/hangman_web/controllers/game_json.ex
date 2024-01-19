defmodule HangmanWeb.GameJSON do
  alias Hangman.Games.Game

  @doc """
  Renders a list of games.
  """
  def index(%{games: games}) do
    %{games: for(game <- games, do: data(game))}
  end

  @doc """
  Renders a single game.
  """
  def show(%{game: game}) do
    %{game: data(game)}
  end

  defp data(%Game{} = game) do
    %{
      id: game.id,
      user: game.user,
      correct_word: game.correct_word,
      guessed_letters: game.guessed_letters,
      finished: game.finished
    }
  end

  def response(%{response: res}) do
    %{
      guessed_correctly: res.guessed_correctly,
      guessed_wrong: res.guessed_wrong,
      correct: res.correct,
      finished: res.finished
    }
  end

  def response_orig(%{game: res}) do
    %{
      guessed_correctly: List.duplicate(".", String.length(res.correct_word)),
      id: res.id
    }
  end
end
