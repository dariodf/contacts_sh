defmodule ContactsShWeb.ContactControllerTest do
  use ContactsShWeb.ConnCase

  alias ContactsSh.Contacts
  alias ContactsSh.Contacts.Contact

  @create_attrs %{
    delete: false,
    email: "email@domain.com",
    last_name: "LastNameA",
    name: "Contact Names",
    phone: "+5491155555555"
  }
  @create_attrs_2 %{
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

  def fixture(:contact) do
    {:ok, contact} = Contacts.create_contact(@create_attrs)
    contact
  end

  def fixture(:contacts) do
    {:ok, contact_2} = Contacts.create_contact(@create_attrs_2)
    {:ok, contact} = Contacts.create_contact(@create_attrs)
    [contact_2, contact]
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_contacts]

    test "lists all contacts ordered by last_name", %{
      conn: conn,
      contacts: [gen_contact_2, gen_contact_1]
    } do
      conn = get(conn, contact_path(conn, :index))
      assert length(json_response(conn, 200)["data"]) == 2
      [contact_1, contact_2] = json_response(conn, 200)["data"]
      assert contact_1["last_name"] == gen_contact_1.last_name
      assert contact_2["last_name"] == gen_contact_2.last_name
    end

    test "get contacts by last_name", %{conn: conn, contacts: [_, gen_contact_1]} do
      conn = get(conn, contact_path(conn, :index, last_name: gen_contact_1.last_name))
      assert length(json_response(conn, 200)["data"]) == 1
      [contact_1] = json_response(conn, 200)["data"]
      assert contact_1["last_name"] == gen_contact_1.last_name
    end
  end

  describe "create contact" do
    test "renders contact when data is valid", %{conn: conn} do
      conn = post(conn, contact_path(conn, :create), contact: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, contact_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "delete" => false,
               "email" => "email@domain.com",
               "last_name" => "LastNameA",
               "name" => "Contact Names",
               "phone" => "+5491155555555"
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, contact_path(conn, :create), contact: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update contact" do
    setup [:create_contact]

    test "renders contact when data is valid", %{conn: conn, contact: %Contact{id: id} = contact} do
      conn = put(conn, contact_path(conn, :update, contact), contact: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, contact_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "delete" => false,
               "email" => "updatedemail@domain.com",
               "last_name" => "UpdatedLastName",
               "name" => "Updated Contact Name",
               "phone" => "+5491166666666"
             }
    end

    test "renders errors when data is invalid", %{conn: conn, contact: contact} do
      conn = put(conn, contact_path(conn, :update, contact), contact: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete contact" do
    setup [:create_contact]

    test "deletes chosen contact", %{conn: conn, contact: contact} do
      conn = delete(conn, contact_path(conn, :delete, contact))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, contact_path(conn, :show, contact))
      end)
    end
  end

  defp create_contact(_) do
    contact = fixture(:contact)
    {:ok, contact: contact}
  end

  defp create_contacts(_) do
    contacts = fixture(:contacts)
    {:ok, contacts: contacts}
  end
end
