defmodule ChatWeb.PageLive do
  use ChatWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    # topics = ChatWeb.Pre
    topics = ChatWeb.Presence.list(socket)
    Logger.info(topics)
    {:ok, assign(socket, query: "", results: %{})}
  end

  @impl true
  def handle_event("random-room", _params, socket) do
    # generate a random room name
    # the <> operator concatenates 2 strings i.e. "/" and "abcd-efgh" => "/abdc-efgh"
    slug = "/" <> MnemonicSlugs.generate_slug(2)
    Logger.info(slug)
    {:noreply, push_redirect(socket, to: slug)}
  end
end
