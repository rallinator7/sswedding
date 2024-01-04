defmodule Sqlite.Repo.Migrations.CreateGuests do
  use Ecto.Migration

  def change do
    create table(:guests, primary_key: false) do
      add :guest_id, :string, primary_key: true, null: false
      add :name, :string, null: false
      add :event, :string, null: false
      add :attending, :boolean, null: false
      add :food_allergies, :string
    end
  end
end
