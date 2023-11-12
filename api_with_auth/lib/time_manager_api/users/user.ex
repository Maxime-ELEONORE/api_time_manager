defmodule TimeManagerApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :username, :string
    field :email, :string
    field :role, :string
    belongs_to :account, TimeManagerApi.Accounts.Account
    has_many :working_times, TimeManagerApi.WorkingTimes.WorkingTime
    has_many :clocks, TimeManagerApi.Clocks.Clock
    many_to_many :teams, TimeManagerApi.Teams.Team, join_through: "team_memberships"
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:account_id, :role, :email, :username])
    |> validate_required([:account_id, :role, :email, :username])
  end
end
