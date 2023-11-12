defmodule TimeManagerApi.WorkingTimes.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "workingtimes" do
    field :start, :naive_datetime
    field :end, :naive_datetime
    belongs_to :user, TimeManagerApi.Users.User
    timestamps()
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:user_id, :start, :end])
    |> validate_required([:start, :end])
  end
end
