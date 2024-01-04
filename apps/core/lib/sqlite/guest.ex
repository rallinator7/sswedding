defmodule Sqlite.Guest do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @id_key :guest_id
  @primary_key {@id_key, :string, autogenerate: false}
  @foreign_key_type :string
  schema "guests" do
    field(:name, :string)
    field :event, Ecto.Enum, values: [:wedding, :reception]
    field(:attending, :boolean)
    field(:food_allergies, :string)
    has_one :plus_ones, Sqlite.PlusOne, foreign_key: :guest_id
  end

  def create_guest(guest = %Domain.Guest{plus_one: nil}) do
    %__MODULE__{}
    |> create_changeset(Map.from_struct(guest))
    |> Sqlite.Repo.insert()
  end

  def create_guest(guest = %Domain.Guest{}) do
    Sqlite.Repo.transaction(fn ->
      %__MODULE__{}
      |> create_changeset(Map.from_struct(guest))
      |> Sqlite.Repo.insert()
      |> create_guest_plus_one(guest.plus_one)
    end)
  end

  def create_changeset(struct = %__MODULE__{}, params \\ %{}) do
    struct
    |> cast(params, [@id_key, :name, :attending, :event, :food_allergies])
    |> validate_required([@id_key, :name, :attending, :event])
  end

  defp create_guest_plus_one({:ok, guest}, plus_one = %Domain.PlusOne{}) do
    Sqlite.PlusOne.create_plus_one(plus_one, guest)
  end

  def all_guests do
    Sqlite.Repo.all(from g in Sqlite.Guest, preload: [:plus_ones])
    |> Enum.map(&to_domain_guest/1)
  end

  def to_domain_guest(guest = %Sqlite.Guest{plus_ones: nil}) do
    Domain.Guest.new(guest.guest_id)
    |> Domain.Guest.guest_name(guest.name)
    |> Domain.Guest.guest_event(guest.event)
    |> Domain.Guest.guest_attending(guest.attending)
    |> Domain.Guest.guest_food_allergies(guest.food_allergies)
  end

  def to_domain_guest(guest = %Sqlite.Guest{plus_ones: plus_one}) do
    Domain.Guest.new(guest.guest_id)
    |> Domain.Guest.guest_name(guest.name)
    |> Domain.Guest.guest_event(guest.event)
    |> Domain.Guest.guest_attending(guest.attending)
    |> Domain.Guest.guest_food_allergies(guest.food_allergies)
    |> Domain.Guest.guest_plus_one(plus_one |> Sqlite.PlusOne.to_domain_plus_one())
  end
end
