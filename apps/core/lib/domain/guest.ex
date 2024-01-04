defmodule Domain.Guest do
  alias Domain.Id

  defstruct [:guest_id, :name, :event, :attending, :plus_one, :food_allergies]

  def new_wedding_guest do
    new()
    |> assign_event(:wedding)
  end

  def new_reception_guest do
    new()
    |> assign_event(:reception)
  end

  def guest_name(guest = %__MODULE__{}, name) do
    guest
    |> Map.put(:name, name)
  end

  def guest_attending(guest = %__MODULE__{}, attending) do
    guest
    |> Map.put(:attending, attending)
  end

  def guest_food_allergies(guest = %__MODULE__{}, allergies) do
    guest
    |> Map.put(:food_allergies, allergies)
  end

  def guest_plus_one(guest = %__MODULE__{}, plus_one) do
    guest
    |> Map.put(:plus_one, plus_one)
  end

  def guest_event(guest = %__MODULE__{}, event) do
    guest
    |> Map.put(:event, event)
  end

  def new(id \\ Id.new()) do
    %__MODULE__{guest_id: id}
  end

  defp assign_event(guest, event) do
    guest
    |> Map.put(:event, event)
  end
end
