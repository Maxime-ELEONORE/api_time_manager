defmodule TimeManagerApi.Clocks.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :naive_datetime
    belongs_to :user, TimeManagerApi.Users.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:user_id, :time, :status])
    |> validate_required([:time, :status])
  end
end
