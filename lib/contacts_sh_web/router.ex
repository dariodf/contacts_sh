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
end
