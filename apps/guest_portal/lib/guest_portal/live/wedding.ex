defmodule GuestPortal.Live.Wedding do
  use GuestPortal, :live_view
  alias Domain.Guest
  alias Domain.PlusOne

  def mount(_params, _session, socket) do
    {:ok,
     assign(
       socket,
       guest_name: "",
       guest_food_allergies: "",
       attending: false,
       plus_one: false,
       plus_one_food_allergies: "",
       plus_one_name: "",
       can_submit: false,
       trigger_submit: false
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col justify-center items-center w-full py-8">
      <h1 class="text-primary text-4xl">Sydney & Shay's Wedding</h1>
      <h2 class="text-primary text-2xl">January 26th, 2024</h2>
      <form
        class="flex flex-col justify-center items-center w-full"
        phx-submit="save"
        phx-trigger-action={@trigger_submit}
        action={~p"/submitted"}
      >
        <div class="flex flex-col justify-center items-center w-full">
          <div class="form-control pb-2 w-full max-w-xs">
            <label class="label">
              <span class="label-text text-primary font-semibold">Your Name*</span>
            </label>
            <input
              phx-change="guest_name"
              phx-debounce="100"
              type="text"
              name="guest_name"
              class="input input-bordered border-secondary input-secondary bg-slate-100 text-primary w-full max-w-xs"
              value={@guest_name}
            />
          </div>
          <div class="form-control w-full max-w-xs">
            <label class="label cursor-pointer font-semibold">
              <span class="label-text text-primary">Will you be attending?</span>
              <input
                type="checkbox"
                name="attending"
                checked={@attending}
                class="checkbox checkbox-secondary bg-slate-100"
                phx-change="attending"
              />
            </label>
          </div>
        </div>

        <div :if={@attending} class="flex flex-col justify-center items-center w-full">
          <div class="form-control pb-2 w-full max-w-xs">
            <label class="label">
              <span class="label-text text-primary font-semibold">
                Please list any food allergies.
              </span>
            </label>
            <textarea
              phx-change="guest_food_allergies"
              phx-debounce="200"
              name="guest_food_allergies"
              class="textarea textarea-secondary text-primary border-secondary textarea-lg bg-slate-100"
            ><%= @guest_food_allergies %></textarea>
          </div>
          <div class="form-control w-full max-w-xs">
            <label class="label cursor-pointer">
              <span class="label-text text-primary font-semibold">
                Will you be bringing a plus one?
              </span>
              <input
                type="checkbox"
                name="plus_one"
                class="checkbox checkbox-secondary bg-slate-100"
                checked={@plus_one}
                phx-change="plus_one"
              />
            </label>
          </div>
        </div>

        <div :if={@attending && @plus_one} class="flex flex-col justify-center items-center w-full">
          <div class="form-control pb-2 w-full max-w-xs">
            <label class="label">
              <span class="label-text text-primary font-semibold">Their Name*</span>
            </label>
            <input
              phx-change="plus_one_name"
              phx-debounce="100"
              type="text"
              name="plus_one_name"
              class="input input-bordered border-secondary input-secondary text-primary w-full max-w-xs bg-slate-100"
              value={@plus_one_name}
            />
          </div>
          <div class="form-control pb-2 w-full max-w-xs">
            <label class="label">
              <span class="label-text text-primary font-semibold">
                Please list any food allergies.
              </span>
            </label>
            <textarea
              phx-change="plus_one_food_allergies"
              phx-debounce="200"
              name="plus_one_food_allergies"
              class="textarea textarea-secondary text-primary border-secondary textarea-lg bg-slate-100"
            ><%= @plus_one_food_allergies %></textarea>
          </div>
        </div>
        <div class="py-4 flex flex-col justify-center items-center w-full">
          <button :if={@can_submit} class="btn btn-primary w-full max-w-xs">
            Submit
          </button>
          <button :if={!@can_submit} class="btn btn-disabled w-full max-w-xs">Submit</button>
        </div>
      </form>
    </div>
    """
  end

  def handle_event("guest_name", params, socket) do
    guest_name = Map.fetch!(params, "guest_name")
    plus_one = socket.assigns.plus_one
    plus_one_name = socket.assigns.plus_one_name
    can_submit = can_submit?(guest_name, plus_one, plus_one_name)

    {:noreply, assign(socket, guest_name: guest_name, can_submit: can_submit)}
  end

  def handle_event("attending", _params, socket) do
    attending = socket.assigns.attending
    {:noreply, assign(socket, attending: !attending)}
  end

  def handle_event("guest_food_allergies", params, socket) do
    allergies = Map.fetch!(params, "guest_food_allergies")
    {:noreply, assign(socket, guest_food_allergies: allergies)}
  end

  def handle_event("plus_one", _params, socket) do
    guest_name = socket.assigns.guest_name
    plus_one = !socket.assigns.plus_one
    plus_one_name = socket.assigns.plus_one_name
    can_submit = can_submit?(guest_name, plus_one, plus_one_name)

    {:noreply, assign(socket, plus_one: plus_one, can_submit: can_submit)}
  end

  def handle_event("plus_one_name", params, socket) do
    plus_one_name = Map.fetch!(params, "plus_one_name")
    plus_one = socket.assigns.plus_one
    guest_name = socket.assigns.guest_name
    can_submit = can_submit?(guest_name, plus_one, plus_one_name)

    {:noreply, assign(socket, plus_one_name: plus_one_name, can_submit: can_submit)}
  end

  def handle_event("plus_one_food_allergies", params, socket) do
    allergies = Map.fetch!(params, "plus_one_food_allergies")
    {:noreply, assign(socket, plus_one_food_allergies: allergies)}
  end

  def handle_event("save", _params, socket) do
    save_guest(socket.assigns)

    {:noreply, assign(socket, trigger_submit: true)}
  end

  def save_guest(assigns = %{plus_one: true}) do
    plus_one =
      PlusOne.new()
      |> PlusOne.plus_one_name(assigns.plus_one_name)
      |> PlusOne.plus_one_food_allergies(assigns.plus_one_food_allergies)

    Guest.new()
    |> Guest.guest_event(:wedding)
    |> Guest.guest_name(assigns.guest_name)
    |> Guest.guest_attending(assigns.attending)
    |> Guest.guest_food_allergies(assigns.guest_food_allergies)
    |> Guest.guest_plus_one(plus_one)
    |> Sqlite.Guest.create_guest()
  end

  def save_guest(assigns) do
    Guest.new()
    |> Guest.guest_event(:wedding)
    |> Guest.guest_name(assigns.guest_name)
    |> Guest.guest_attending(assigns.attending)
    |> Guest.guest_food_allergies(assigns.guest_food_allergies)
    |> Sqlite.Guest.create_guest()
  end

  defp can_submit?("", _plus_one, _plus_one_name) do
    false
  end

  defp can_submit?(_name, false, _plus_one_name) do
    true
  end

  defp can_submit?(_name, true, "") do
    false
  end

  defp can_submit?(_name, true, _plus_one_name) do
    true
  end
end
