defmodule HangmanWeb.GameControllerTest do
  use HangmanWeb.ConnCase

  import Hangman.GamesFixtures

  alias Hangman.Games.Game

  @create_attrs %{
    user: "some user",
    finished: true,
    correct_word: "some correct_word",
    guessed_letters: ["option1", "option2"]
  }
  @update_attrs %{
    user: "some updated user",
    finished: false,
    correct_word: "some updated correct_word",
    guessed_letters: ["option1"]
  }
  @invalid_attrs %{user: nil, finished: nil, correct_word: nil, guessed_letters: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all games", %{conn: conn} do
      conn = get(conn, ~p"/api/games")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create game" do
    test "renders game when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/games", game: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/games/#{id}")

      assert %{
               "id" => ^id,
               "correct_word" => "some correct_word",
               "finished" => true,
               "guessed_letters" => ["option1", "option2"],
               "user" => "some user"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/games", game: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update game" do
    setup [:create_game]

    test "renders game when data is valid", %{conn: conn, game: %Game{id: id} = game} do
      conn = put(conn, ~p"/api/games/#{game}", game: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/games/#{id}")

      assert %{
               "id" => ^id,
               "correct_word" => "some updated correct_word",
               "finished" => false,
               "guessed_letters" => ["option1"],
               "user" => "some updated user"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, game: game} do
      conn = put(conn, ~p"/api/games/#{game}", game: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete game" do
    setup [:create_game]

    test "deletes chosen game", %{conn: conn, game: game} do
      conn = delete(conn, ~p"/api/games/#{game}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/games/#{game}")
      end
    end
  end

  defp create_game(_) do
    game = game_fixture()
    %{game: game}
  end
end
