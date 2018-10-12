defmodule ContactsShWeb.Router do
  use ContactsShWeb, :router

  @moduledoc false
  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ContactsShWeb do
    pipe_through(:api)

    resources("/contacts", ContactController, except: [:new, :edit])
  end

  scope "/" do
    forward("/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :contacts_sh,
      swagger_file: "swagger.json"
    )
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Contacts SH"
      }
    }
  end
end
