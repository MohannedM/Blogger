defmodule Blogger.User do
    use Blogger.Web, :model

    schema "users" do
        field :name, :string
        field :email, :string
        field :password, :string
        has_many :posts, Blogger.Post
        many_to_many :activities, Blogger.Activity, join_through: "users_activities"
        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:name, :email, :password])
        |> validate_required([:name, :email, :password])
        |> unique_constraint(:email)
    end
end