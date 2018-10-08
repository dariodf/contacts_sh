defmodule ContactsSh.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :name, :string
      add :last_name, :string
      add :email, :string
      add :phone, :string
      add :delete, :boolean, default: false, null: false

      timestamps()
    end

  end
end
