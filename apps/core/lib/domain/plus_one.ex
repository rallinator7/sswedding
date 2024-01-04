defmodule Domain.PlusOne do
  alias Domain.Id

  defstruct [:plus_one_id, :name, :food_allergies]

  def new(id \\ Id.new()) do
    %__MODULE__{plus_one_id: id}
  end

  def plus_one_name(plus_one = %__MODULE__{}, name) do
    plus_one
    |> Map.put(:name, name)
  end

  def plus_one_food_allergies(plus_one = %__MODULE__{}, allergies) do
    plus_one
    |> Map.put(:food_allergies, allergies)
  end
end
