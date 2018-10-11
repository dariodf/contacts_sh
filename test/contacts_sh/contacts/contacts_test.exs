defmodule ContactsSh.ContactsTest do
  use ContactsSh.DataCase

  alias ContactsSh.Contacts

  describe "contacts" do
    alias ContactsSh.Contacts.Contact

    @valid_attrs %{
      delete: false,
      email: "email@domain.com",
      last_name: "LastNameA",
      name: "Contact Names",
      phone: "+5491155555555"
    }
    @valid_attrs_2 %{
      delete: false,
      email: "email@domain.com",
      last_name: "LastNameB",
      name: "Contact Names",
      phone: "+5491155555555"
    }
    @update_attrs %{
      delete: false,
      email: "updatedemail@domain.com",
      last_name: "UpdatedLastName",
      name: "Updated Contact Name",
      phone: "+5491166666666"
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

    test "list_contacts/0 shouldn't return contacts marked for deletion" do
      [gen_contact_2, gen_contact_1] = contacts_fixture()
      contacts = Contacts.list_contacts()
      assert length(contacts) == 2
      [contact_1, _] = contacts
      Contacts.delete_contact(contact_1)
      assert length(Contacts.list_contacts()) == 1
    end

    test "list_contacts_by_last_name/1 returns all contacts with the specified last_name" do
      [_, gen_contact_1] = contacts_fixture()
      contacts = Contacts.list_contacts_by_last_name(gen_contact_1.last_name)
      assert length(contacts) == 1
      [contact_1] = contacts
      assert contact_1.last_name == gen_contact_1.last_name
    end

    test "list_contacts_by_last_name/1 shouldn't return contacts marked for deletion" do
      [_, gen_contact_1] = contacts_fixture()
      contacts = Contacts.list_contacts_by_last_name(gen_contact_1.last_name)
      assert length(contacts) == 1
      [contact_1] = contacts
      Contacts.delete_contact(contact_1)
      assert length(Contacts.list_contacts_by_last_name(gen_contact_1.last_name)) == 0
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = contact_fixture()
      assert Contacts.get_contact!(contact.id) == contact
    end

    test "get_contact!/1 shouldn't return a contact marked for deletion" do
      contact = contact_fixture()
      assert Contacts.get_contact!(contact.id) == contact
      Contacts.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> Contacts.get_contact!(contact.id) end
    end

    test "create_contact/1 with valid data creates a contact" do
      assert {:ok, %Contact{} = contact} = Contacts.create_contact(@valid_attrs)
      assert contact.delete == false
      assert contact.email == "email@domain.com"
      assert contact.last_name == "LastNameA"
      assert contact.name == "Contact Names"
      assert contact.phone == "+5491155555555"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contacts.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = contact_fixture()
      assert {:ok, contact} = Contacts.update_contact(contact, @update_attrs)
      assert %Contact{} = contact
      assert contact.delete == false
      assert contact.email == "updatedemail@domain.com"
      assert contact.last_name == "UpdatedLastName"
      assert contact.name == "Updated Contact Name"
      assert contact.phone == "+5491166666666"
    end

    test "update_contact/2 with invalid data returns error changeset" do
      contact = contact_fixture()
      assert {:error, %Ecto.Changeset{}} = Contacts.update_contact(contact, @invalid_attrs)
      assert contact == Contacts.get_contact!(contact.id)
    end

    test "delete_contact/1 marks the contact for deletion" do
      contact = contact_fixture()
      assert {:ok, %Contact{}} = Contacts.delete_contact(contact)
      assert true == Contacts.get_contact!(contact.id).delete
    end

    test "change_contact/1 returns a contact changeset" do
      contact = contact_fixture()
      assert %Ecto.Changeset{} = Contacts.change_contact(contact)
    end
  end
end
