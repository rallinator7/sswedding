defmodule GuestPortal.Live.Submitted do
  use GuestPortal, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col justify-center text-center items-center w-full py-8">
      <h2 class="text-primary text-4xl text-center">
        Thank you for your response!
      </h2>
    </div>
    """
  end
end
