defmodule ContactsShWeb.ContactView do
  use ContactsShWeb, :view
  alias ContactsShWeb.ContactView

  @moduledoc false
  def render("index.json", %{contacts: contacts}) do
    %{data: render_many(contacts, ContactView, "contact.json")}
  end

  def render("show.json", %{contact: contact}) do
    %{data: render_one(contact, ContactView, "contact.json")}
  end

  def render("contact.json", %{contact: contact}) do
    %{
      id: contact.id,
      name: contact.name,
      last_name: contact.last_name,
      email: contact.email,
      phone: contact.phone,
      delete: contact.delete
    }
  end
end
