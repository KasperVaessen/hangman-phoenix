defmodule Hangman.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :user, :string
      add :correct_word, :string
      add :guessed_letters, {:array, :string}
      add :finished, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
