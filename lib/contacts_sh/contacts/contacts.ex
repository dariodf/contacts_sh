defmodule ContactsSh.Contacts do
  @moduledoc """
  The Contacts context.
  """

  import Ecto.Query, warn: false
  alias ContactsSh.Repo

  alias ContactsSh.Contacts.Contact

  @type contact() :: %Contact{}
  @type contact(last_name) :: %Contact{last_name: last_name}
  @type contact_changeset() :: %Ecto.Changeset{}
  @doc """
  Returns the list of contacts.

  ## Examples

      iex> list_contacts()
      [%Contact{}, ...]

  """
  @spec list_contacts() :: list(contact())
  def list_contacts do
    Contact
    |> order_by(asc: :last_name)
    |> where(delete: false)
    |> Repo.all()
  end

  @doc """
  Returns the list of contacts by their last name.

  ## Examples

      iex> list_contacts_by_last_name("LastNameA")
      [%Contact{last_name: "LastNameA"}, ...]

  """
  @spec list_contacts_by_last_name(last_name) :: list(contact(last_name))
        when last_name: String.t()
  def list_contacts_by_last_name(last_name) do
    Contact
    |> where(last_name: ^last_name)
    |> where(delete: false)
    |> Repo.all()
  end

  @doc """
  Gets a single contact.

  Raises `Ecto.NoResultsError` if the Contact does not exist.

  ## Examples

      iex> get_contact!(123)
      %Contact{}

      iex> get_contact!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_contact!(integer()) :: contact()
  def get_contact!(id) do
    Contact
    |> where(id: ^id)
    |> where(delete: false)
    |> Repo.one!()
  end

  @doc """
  Creates a contact.

  ## Examples

      iex> create_contact(%{field: value})
      {:ok, %Contact{}}

      iex> create_contact(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_contact(map()) :: {:ok, contact()} | {:error, contact_changeset()}
  def create_contact(attrs \\ %{}) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a contact.

  ## Examples

      iex> update_contact(contact, %{field: new_value})
      {:ok, %Contact{}}

      iex> update_contact(contact, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_contact(contact(), map()) :: {:ok, contact()} | {:error, contact_changeset()}
  def update_contact(%Contact{} = contact, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Marks a Contact for deletion. The contact shouldn't appear in listings anymore.

  ## Examples

      iex> delete_contact(contact)
      {:ok, %Contact{}}

      iex> delete_contact(contact)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_contact(contact()) :: {:ok, contact()} | {:error, contact_changeset()}
  def delete_contact(%Contact{} = contact) do
    contact
    |> Contact.changeset(%{delete: true})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contact changes.

  ## Examples

      iex> change_contact(contact)
      %Ecto.Changeset{source: %Contact{}}

  """
  def change_contact(%Contact{} = contact) do
    Contact.changeset(contact, %{})
  end
end
