defmodule ContactsShWeb do
  @moduledoc false

  def controller do
    quote do
      use Phoenix.Controller, namespace: ContactsShWeb
      import Plug.Conn
      import ContactsShWeb.Router.Helpers
      import ContactsShWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/contacts_sh_web/templates",
        namespace: ContactsShWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import ContactsShWeb.Router.Helpers
      import ContactsShWeb.ErrorHelpers
      import ContactsShWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ContactsShWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
