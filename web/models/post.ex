defmodule Blogger.Post do
    use Blogger.Web, :model

    schema "posts" do
        field :title, :string
        field :body, :string
        belongs_to :user, Blogger.User

        timestamps()
    end

    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:title, :body, :user_id])
        |> validate_required([:title, :body, :user_id])
    end
end