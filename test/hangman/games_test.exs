defmodule Hangman.GamesTest do
  use Hangman.DataCase

  alias Hangman.Games

  describe "games" do
    alias Hangman.Games.Game

    import Hangman.GamesFixtures

    @invalid_attrs %{user: nil, finished: nil, correct_word: nil, guessed_letters: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Games.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Games.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{user: "some user", finished: true, correct_word: "some correct_word", guessed_letters: ["option1", "option2"]}

      assert {:ok, %Game{} = game} = Games.create_game(valid_attrs)
      assert game.user == "some user"
      assert game.finished == true
      assert game.correct_word == "some correct_word"
      assert game.guessed_letters == ["option1", "option2"]
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Games.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{user: "some updated user", finished: false, correct_word: "some updated correct_word", guessed_letters: ["option1"]}

      assert {:ok, %Game{} = game} = Games.update_game(game, update_attrs)
      assert game.user == "some updated user"
      assert game.finished == false
      assert game.correct_word == "some updated correct_word"
      assert game.guessed_letters == ["option1"]
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Games.update_game(game, @invalid_attrs)
      assert game == Games.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Games.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Games.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Games.change_game(game)
    end
  end
end
