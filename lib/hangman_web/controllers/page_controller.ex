defmodule HangmanWeb.PageController do
  use HangmanWeb, :controller
  use Phoenix.Component

  def home(conn, _params) do
    url = "http://localhost:4000/api/create_game"
    {:ok, resp} = Req.post(url)
    %{"guessed_correctly" => lis, "id" => id} = resp.body

    guess = %{
      "guess" => ""
    }
    form = to_form(guess)

    render(conn, :home, resp: lis, form: form)
  end

  def handle_event("save", %{:guess => guess}, socket) do
    IO.puts(guess)
  end
end
