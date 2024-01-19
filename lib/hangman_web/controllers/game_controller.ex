defmodule HangmanWeb.GameController do
  use HangmanWeb, :controller

  alias Hangman.Games
  alias Hangman.Games.Game

  action_fallback HangmanWeb.FallbackController

  def index(conn, _params) do
    games = Games.list_games()
    render(conn, :index, games: games)
  end

  def create(conn, %{"game" => game_params}) do
    with {:ok, %Game{} = game} <- Games.create_game(game_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/games/#{game}")
      |> render(:show, game: game)
    end
  end

  def create_game(conn, _) do
    possible_words = ["cake","car","Qdentity"]
    word = Enum.random(possible_words)
    game_params = %{
      user: "user",
      correct_word: word,
      guessed_letters: []
    }


    with {:ok, %Game{} = game} <- Games.create_game(game_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/games/#{game}")
      |> render(:response_orig, game: game)
    end

  end

  def make_guess(conn, %{"id" => id, "guess" => guess}) do
    game = Games.get_game!(id)
      %{
        id: _,
        user: _,
        finished: _,
        correct_word: correct_word,
        guessed_letters: guessed_letters
      } = game
    if (not is_bitstring(guess)) or (not Regex.match?(~r/^[A-Za-z]$/, guess)) or Enum.member?(guessed_letters, guess) do
      send_resp(conn, 422, "invalid guess")
    else
      guess = String.downcase(guess)
      new_guessed = [guess|guessed_letters]
      guessed_correctly = String.graphemes(correct_word) |> Enum.map(fn x -> if Enum.member?(new_guessed,x) do x else "." end end)
      guessed_wrong = Enum.filter(new_guessed, fn x -> not String.contains?(correct_word, x) end)
      correct = String.contains?(correct_word, guess)
      finished = String.graphemes(correct_word) |> Enum.filter(fn x -> not Enum.member?(new_guessed,x) end) |> Enum.count == 0
      response = %{
        guessed_correctly: guessed_correctly,
        guessed_wrong: guessed_wrong,
        correct: correct,
        finished: finished
      }
      with {:ok, %Game{} = _} <- Games.update_game(game, %{guessed_letters: new_guessed, finished: finished}) do
        render(conn, :response, response: response)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    game = Games.get_game!(id)
    render(conn, :show, game: game)
  end

  def update(conn, %{"id" => id, "game" => game_params}) do
    game = Games.get_game!(id)

    with {:ok, %Game{} = game} <- Games.update_game(game, game_params) do
      render(conn, :show, game: game)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = Games.get_game!(id)

    with {:ok, %Game{}} <- Games.delete_game(game) do
      send_resp(conn, :no_content, "")
    end
  end
end
