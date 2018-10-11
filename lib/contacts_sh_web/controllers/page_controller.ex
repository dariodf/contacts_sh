defmodule ContactsShWeb.PageController do
  use ContactsShWeb, :controller

  @moduledoc false
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
