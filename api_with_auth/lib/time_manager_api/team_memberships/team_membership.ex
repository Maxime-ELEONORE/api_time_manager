defmodule TimeManagerApi.TeamMemberships.TeamMembership do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "team_memberships" do
    belongs_to :user, TimeManagerApi.Users.User, foreign_key: :user_id
    belongs_to :team, TimeManagerApi.Teams.Team, foreign_key: :team_id

    timestamps()
  end

  @doc false
  def changeset(team_membership, attrs) do
    team_membership
    |> cast(attrs, [:user_id, :team_id])
    |> validate_required([])
  end
end
