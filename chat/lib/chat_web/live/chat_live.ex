defmodule ChatWeb.ChatLive do
  use ChatWeb, :live_view

  def mount(params, _session, socket) do
    {:ok, assign(socket, room: Map.get(params, "room_id"), id: nil, prompt: "")}
  end

  def handle_event("prompt", %{"prompt" => prompt}, socket) do
    # IO.inspect(prompt, label: "PROMPT")
    socket = assign(socket, id: UUID.uuid4(), prompt: prompt)
    # IO.inspect(socket, label: "SOCKET")
    {:noreply, socket}
  end

  def response(prompt) do
    Chat.OpenAI.callAPI(prompt)
  end

  def render(assigns) do
    ~H"""
    <pre><%= response(@prompt) %></pre>
    <br />
    <form phx-submit="prompt">
      <input
        type="text"
        name="prompt"
        placeholder="Ask GPT a question..."
        autofocus
        autocomplete="off"
      />
    </form>
    """
  end
end
