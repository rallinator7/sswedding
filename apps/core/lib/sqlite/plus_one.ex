defmodule Sqlite.PlusOne do
  use Ecto.Schema
  import Ecto.Changeset

  @id_key :plus_one_id
  @primary_key {@id_key, :string, autogenerate: false}
  schema "plus_ones" do
    field :name, :string
    field :food_allergies, :string
    belongs_to(:guest, Sqlite.Guest, foreign_key: :guest_id, references: :guest_id, type: :string)
  end

  def create_plus_one(plus_one = %Domain.PlusOne{}, guest = %Sqlite.Guest{}) do
    Ecto.build_assoc(guest, :plus_ones, Map.from_struct(plus_one))
    |> create_changeset()
    |> Sqlite.Repo.insert()
  end

  def create_changeset(struct = %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, [@id_key, :name, :food_allergies])
    |> validate_required([@id_key, :name])
  end

  def to_domain_plus_one(plus_one = %Sqlite.PlusOne{}) do
    Domain.PlusOne.new(plus_one.plus_one_id)
    |> Domain.PlusOne.plus_one_name(plus_one.name)
    |> Domain.PlusOne.plus_one_food_allergies(plus_one.food_allergies)
  end
end
