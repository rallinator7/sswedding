defmodule Domain.Id do
  def new() do
    Ecto.UUID.generate()
  end
end
