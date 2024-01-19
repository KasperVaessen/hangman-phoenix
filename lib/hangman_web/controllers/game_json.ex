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
    guessed_correctly = String.graphemes(game.correct_word) |> Enum.map(fn x -> if Enum.member?(game.guessed_letters,x) do x else "." end end)
    guessed_wrong = Enum.filter(game.guessed_letters, fn x -> not String.contains?(game.correct_word, x) end)
    %{
      id: game.id,
      guessed_correctly: guessed_correctly,
      guessed_wrong: guessed_wrong,
      finished: game.finished
    }
  end

  def response_orig(%{game: res}) do
    %{
      guessed_correctly: List.duplicate(".", String.length(res.correct_word)),
      id: res.id
    }
  end
end
