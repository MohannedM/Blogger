defmodule Blogger.UserActivity do
    use Blogger.Web, :model
  
    import Ecto.Changeset
  
    schema "users_activities" do
      belongs_to :user, Blogger.User
      belongs_to :activity, Blogger.Activity
    end
  
    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:user_id, :activity_id])
      |> validate_required([:user_id, :activity_id])
    end
  end