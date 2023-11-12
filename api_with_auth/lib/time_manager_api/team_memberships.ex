defmodule TimeManagerApi.TeamMemberships do
  @moduledoc """
  The TeamMemberships context.
  """

  import Ecto.Query, warn: false
  alias TimeManagerApi.Repo

  alias TimeManagerApi.TeamMemberships.TeamMembership

  @doc """
  Returns the list of team_memberships.

  ## Examples

      iex> list_team_memberships()
      [%TeamMembership{}, ...]

  """
  def list_team_memberships do
    Repo.all(TeamMembership)
  end

  @doc """
  Gets a single team_membership.

  Raises `Ecto.NoResultsError` if the Team membership does not exist.

  ## Examples

      iex> get_team_membership!(123)
      %TeamMembership{}

      iex> get_team_membership!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team_membership!(id), do: Repo.get!(TeamMembership, id)

  @doc """
  Creates a team_membership.

  ## Examples

      iex> create_team_membership(%{field: value})
      {:ok, %TeamMembership{}}

      iex> create_team_membership(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team_membership(attrs \\ %{}) do
    %TeamMembership{}
    |> TeamMembership.changeset(attrs)
    |> Repo.insert()
  end

  def remove_member(user_id, team_id) do
    query = from tm in TeamMembership,
    where: tm.user_id == ^user_id and tm.team_id == ^team_id

    {count, _} = Repo.delete_all(query)
    if count > 0 do
      {:ok, count}
    else
      {:error, :not_found}
    end
  end

  @doc """
  Updates a team_membership.

  ## Examples

      iex> update_team_membership(team_membership, %{field: new_value})
      {:ok, %TeamMembership{}}

      iex> update_team_membership(team_membership, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team_membership(%TeamMembership{} = team_membership, attrs) do
    team_membership
    |> TeamMembership.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team_membership.

  ## Examples

      iex> delete_team_membership(team_membership)
      {:ok, %TeamMembership{}}

      iex> delete_team_membership(team_membership)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team_membership(%TeamMembership{} = team_membership) do
    Repo.delete(team_membership)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team_membership changes.

  ## Examples

      iex> change_team_membership(team_membership)
      %Ecto.Changeset{data: %TeamMembership{}}

  """
  def change_team_membership(%TeamMembership{} = team_membership, attrs \\ %{}) do
    TeamMembership.changeset(team_membership, attrs)
  end
end
