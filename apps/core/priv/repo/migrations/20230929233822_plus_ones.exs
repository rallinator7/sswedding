defmodule Sqlite.Repo.Migrations.PlusOnes do
  use Ecto.Migration

  def change do
    create table(:plus_ones, primary_key: false) do
      add :plus_one_id, :string, primary_key: true, null: false
      add :name, :string, null: false
      add :food_allergies, :string
      add :guest_id, references(:guests, type: :string, column: :guest_id)
    end

    create unique_index(:plus_ones, [:guest_id])
  end
end
