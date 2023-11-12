defmodule TimeManagerApi.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :email, :string, null: false
      add :hash_password, :string, null: false

      timestamps()
    end

    create unique_index(:accounts, [:email])

  end
end
