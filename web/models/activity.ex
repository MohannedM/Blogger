defmodule Blogger.Activity do
    use Blogger.Web, :model

    schema "activities" do
        field :name, :string
        field :description, :string
        many_to_many :users, Blogger.User, join_through: "users_activities"
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:name, :description])
        |> validate_required([:name, :description])
    end
end