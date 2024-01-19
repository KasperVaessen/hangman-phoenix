defmodule HangmanWeb.PageLive do

  use HangmanWeb, :live_view

  def mount(_params, _session, socket) do
    url = "http://localhost:4000/api/unfinished_games"
    {:ok, resp} = Req.get(url)
    %{"games" => games} = resp.body

    if(Enum.count(games) == 0) do
      handle_event("save2", %{}, socket)
    end

    %{"guessed_correctly" => lis, "id" => id, "guessed_wrong"=> guessed_wrong} = games |> Enum.at(0) |> Map.take(["guessed_correctly", "id", "guessed_wrong"])
    form = to_form(%{"guess" => ""})
    form2 = to_form(%{})

    {:ok, assign(socket, resp: lis)
    |> assign(form: form)
    |> assign(form2: form2)
    |> assign(id: id)
    |> assign(games: games)
    |> assign(guessed_wrong: guessed_wrong)}
  end

  def handle_event("save", %{"guess" => guess}, socket) do
    url = "http://localhost:4000/api/guess"
    body = %{
      "id" => socket.assigns.id,
      "guess" => guess
    }
    {:ok, resp} = Req.post(url,json: body)
    %{"game" => %{
        "finished" => finished,
        "guessed_correctly" => lis,
        "guessed_wrong" => guessed_wrong,
        "id" => _
        }
      } = resp.body

    {:noreply, assign(socket, resp: lis, guessed_wrong: guessed_wrong)}
  end

  def handle_event("save2", %{}, socket) do
    url = "http://localhost:4000/api/create_game"
    {:ok, resp} = Req.post(url)
    {:noreply, push_navigate(socket, to: "/", replace: true)}
  end
end
