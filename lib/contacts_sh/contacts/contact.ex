defmodule ContactsSh.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc false

  schema "contacts" do
    field(:delete, :boolean, default: false)
    field(:email, :string)
    field(:last_name, :string)
    field(:name, :string)
    field(:phone, :string)

    timestamps()
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :last_name, :email, :phone, :delete])
    |> validate_required([:name, :last_name, :email, :phone, :delete])
  end
end
