defmodule ContactsShWeb.FallbackController do
  @moduledoc false
  use ContactsShWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(ContactsShWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(ContactsShWeb.ErrorView, :"404", [])
  end
end
