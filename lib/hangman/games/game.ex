defmodule Hangman.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :user, :string
    field :finished, :boolean, default: false
    field :correct_word, :string
    field :guessed_letters, {:array, :string}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:user, :correct_word, :guessed_letters, :finished])
    |> validate_required([:user, :correct_word, :guessed_letters, :finished])
  end
end
