defmodule ContactsSh.ContactsTest do
  use ContactsSh.DataCase

  alias ContactsSh.Contacts

  describe "contacts" do
    alias ContactsSh.Contacts.Contact

    @valid_attrs %{
      delete: false,
      email: "some email",
      last_name: "LastNameA",
      name: "some name",
      phone: "some phone"
    }
    @valid_attrs_2 %{
      delete: false,
      email: "some email",
      last_name: "LastNameB",
      name: "some name",
      phone: "some phone"
    }
    @update_attrs %{
      delete: false,
      email: "some updated email",
      last_name: "UpdatedLastName",
      name: "some updated name",
      phone: "some updated phone"
    }
    @invalid_attrs %{delete: nil, email: nil, last_name: nil, name: nil, phone: nil}

    def contact_fixture(attrs \\ %{}) do
      {:ok, contact} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Contacts.create_contact()

      contact
    end

    def contacts_fixture() do
      {:ok, contact_2} =
        @valid_attrs_2
        |> Contacts.create_contact()

      {:ok, contact_1} =
        @valid_attrs
        |> Contacts.create_contact()

      [contact_2, contact_1]
    end

    test "list_contacts/0 returns all contacts ordered by last_name" do
      [gen_contact_2, gen_contact_1] = contacts_fixture()
      contacts = Contacts.list_contacts()
      assert length(contacts) == 2
      [contact_1, contact_2] = contacts
      assert contact_1.last_name == gen_contact_1.last_name
      assert contact_2.last_name == gen_contact_2.last_name
    end

    test "list_contacts_by_last_name/1 returns all contacts with the specified last_name" do
      [_, gen_contact_1] = contacts_fixture()
      contacts = Contacts.list_contacts_by_last_name(gen_contact_1.last_name)
      assert length(contacts) == 1
      [contact_1] = contacts
      assert contact_1.last_name == gen_contact_1.last_name
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = contact_fixture()
      assert Contacts.get_contact!(contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      assert {:ok, %Contact{} = contact} = Contacts.create_contact(@valid_attrs)
      assert contact.delete == false
      assert contact.email == "some email"
      assert contact.last_name == "LastNameA"
      assert contact.name == "some name"
      assert contact.phone == "some phone"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contacts.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = contact_fixture()
      assert {:ok, contact} = Contacts.update_contact(contact, @update_attrs)
      assert %Contact{} = contact
      assert contact.delete == false
      assert contact.email == "some updated email"
      assert contact.last_name == "UpdatedLastName"
      assert contact.name == "some updated name"
      assert contact.phone == "some updated phone"
    end

    test "update_contact/2 with invalid data returns error changeset" do
      contact = contact_fixture()
      assert {:error, %Ecto.Changeset{}} = Contacts.update_contact(contact, @invalid_attrs)
      assert contact == Contacts.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{}} = Contacts.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Contacts.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      contact = contact_fixture()
      assert %Ecto.Changeset{} = Contacts.change_contact(contact)
    end
  end
end
