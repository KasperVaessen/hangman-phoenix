defmodule HangmanWeb.PageLive do

  use HangmanWeb, :live_view
  def render(assigns) do
    ~H"""
      <div id="galg">
      <div class="hang-part" id="part1"></div>
      <div class="hang-part" id="part2"></div>
      <div class="hang-part" id="part3"></div>
      <div class="hang-part" id="part4"></div>
      <div class="hang-part" id="part5"></div>
      <div class="hang-part" id="part6"></div>
      <div class="hang-part" id="part7"></div>
      <div class="hang-part" id="part8"></div>
      <div class="hang-part" id="part9"></div>
      <div class="hang-part" id="part10"></div>
      <div class="hang-part" id="part11"></div>

      <%= for item <- @resp do %>
        <div class="letter"> <%= item %> </div>
      <% end %>

      <.form for={@form} phx-submit="save">
        <.input field={@form["guess"]} type="text" />
        <button>Submit</button>
      </.form>
    </div>
   """
  end

  def mount(_params, _session, socket) do
    url = "http://localhost:4000/api/create_game"
    {:ok, resp} = Req.post(url)
    %{"guessed_correctly" => lis, "id" => id} = resp.body
    guess = %{
      "guess" => ""
    }
    form = to_form(guess)

    {:ok, assign(socket, resp: lis) |> assign(form: form) |> assign(id: id)}
  end

  def handle_event("save", %{"guess" => guess}, socket) do
    url = "http://localhost:4000/api/guess"
    body = %{
      "id" => socket.assigns.id,
      "guess" => guess
    }
    {:ok, resp} = Req.post(url,json: body)
    %{
      "guessed_correctly" => lis,
      "guessed_wrong" => wrong,
      "finished" => finished,
      "correct" => correct
      } = resp.body
    IO.puts(lis)

    {:noreply, assign(socket, resp: lis)}
  end
end
