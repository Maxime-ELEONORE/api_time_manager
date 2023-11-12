defmodule TimeManagerApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :username, :string, null: false
      add :email, :string, null: false
      add :role, :string, null: false
      add :account_id, references(:accounts, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:users, [:account_id, :email, :username, :role])
  end
end
