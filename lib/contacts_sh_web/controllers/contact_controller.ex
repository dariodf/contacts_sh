defmodule ContactsShWeb.ContactController do
  use ContactsShWeb, :controller

  @moduledoc false
  alias ContactsSh.Contacts
  alias ContactsSh.Contacts.Contact
  use PhoenixSwagger

  action_fallback(ContactsShWeb.FallbackController)

  def swagger_definitions do
    %{
      Contact:
        swagger_schema do
          title("Contact")
          description("A person's contact information")

          properties do
            name(:string, "Contact name", required: true)
            last_name(:string, "Contact last name", required: true)
            email(:string, "Contact email", required: true)
            phone(:string, "Contact phone number", required: true)
          end

          example(%{
            name: "Darío",
            last_name: "De Filippis",
            email: "dariodefilippis@gmail.com",
            phone: "+5493426103171"
          })
        end,
      ContactRequest:
        swagger_schema do
          title("ContactRequest")
          description("POST body for creating a contact")
          property(:contact, Schema.ref(:Contact), "The contact details")
        end,
      ContactResponse:
        swagger_schema do
          title("ContactResponse")
          description("Response schema for single contact")
          property(:data, Schema.ref(:Contact), "The contact details")
        end,
      ContactsResponse:
        swagger_schema do
          title("ContactsReponse")
          description("Response schema for multiple contacts")
          property(:data, Schema.array(:Contact), "The contacts details")
        end,
      Error:
        swagger_schema do
          title("Errors")
          description("Error responses from the API")

          properties do
            error(:string, "The message of the error raised", required: true)
          end
        end
    }
  end

  swagger_path :index do
    get("/contacts")
    summary("Get contacts")
    description("Gets all contacts. Can be filtered by last name.")
    produces("application/json")
    tag("Contacts")

    parameters do
      last_name(:query, :string, "Last Name", required: false)
    end

    response(200, "Success", Schema.ref(:ContactsResponse))
  end

  def index(conn, %{"last_name" => last_name}) do
    contacts = Contacts.list_contacts_by_last_name(last_name)
    render(conn, "index.json", contacts: contacts)
  end

  def index(conn, _params) do
    contacts = Contacts.list_contacts()
    render(conn, "index.json", contacts: contacts)
  end

  swagger_path :create do
    post("/contacts")
    summary("Creates a new contact")
    description("Creates a new contact")

    parameters do
      contact(:body, Schema.ref(:ContactRequest), "New contact information", required: true)
    end

    response(201, "Ok", Schema.ref(:ContactResponse))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def create(conn, %{"contact" => contact_params}) do
    with {:ok, %Contact{} = contact} <- Contacts.create_contact(contact_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", contact_path(conn, :show, contact))
      |> render("show.json", contact: contact)
    end
  end

  swagger_path(:show) do
    summary("Show Contact")
    description("Show a contact by ID")
    produces("application/json")
    parameter(:id, :path, :integer, "Contact ID", required: true, example: 123)

    response(200, "OK", Schema.ref(:ContactResponse))
    response(404, "Not Found", Schema.ref(:Error))
  end

  def show(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    render(conn, "show.json", contact: contact)
  end

  swagger_path(:update) do
    put("/contacts/{id}")
    summary("Update contact")
    description("Update all attributes of a contact")
    consumes("application/json")
    produces("application/json")

    parameters do
      id(:path, :integer, "Contact ID", required: true, example: 3)

      contact(:body, Schema.ref(:ContactRequest), "The contact details")
    end

    response(200, "Updated Successfully", Schema.ref(:ContactResponse))
    response(422, "Unprocessable Entity", Schema.ref(:Error))
  end

  def update(conn, %{"id" => id, "contact" => contact_params}) do
    contact = Contacts.get_contact!(id)

    with {:ok, %Contact{} = contact} <- Contacts.update_contact(contact, contact_params) do
      render(conn, "show.json", contact: contact)
    end
  end

  swagger_path(:delete) do
    PhoenixSwagger.Path.delete("/contacts/{id}")
    summary("Delete Contact")
    description("Delete a contact by ID")
    parameter(:id, :path, :integer, "Contact ID", required: true, example: 3)
    response(204, "No Content - Deleted Successfully")
    response(404, "Not Found", Schema.ref(:Error))
  end

  def delete(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)

    with {:ok, %Contact{}} <- Contacts.delete_contact(contact) do
      send_resp(conn, :no_content, "")
    end
  end
end
