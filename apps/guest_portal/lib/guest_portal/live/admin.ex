defmodule GuestPortal.Live.Admin do
  use GuestPortal, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_guests()}
  end

  def render(assigns) do
    ~H"""
    <div class="overflow-x-auto">
      <table class="table table-zebra">
        <!-- head -->
        <thead>
          <tr>
            <th>Guest Name</th>
            <th>Event</th>
            <th>Attending</th>
            <th>Food Allergies</th>
            <th>Plus One Name</th>
            <th>Plus One Food Allergies</th>
          </tr>
        </thead>
        <tbody>
          <!-- row 1 -->
          <tr :for={guest <- @guests}>
            <th><%= guest.name %></th>
            <td><%= guest.event %></td>
            <td><%= guest.attending %></td>
            <td><%= food_allergies(guest.food_allergies) %></td>
            <td><%= plus_one_name(guest.plus_one) %></td>
            <td><%= plus_one_food_allergies(guest.plus_one) %></td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  def assign_guests(socket) do
    assign(socket, :guests, Sqlite.Guest.all_guests())
  end

  def plus_one_name(nil) do
    "-"
  end

  def plus_one_name(plus_one) do
    plus_one.name
  end

  def plus_one_food_allergies(nil) do
    "-"
  end

  def plus_one_food_allergies(plus_one) do
    food_allergies(plus_one.food_allergies)
  end

  def food_allergies(nil) do
    "-"
  end

  def food_allergies(allergies) do
    allergies
  end
end
