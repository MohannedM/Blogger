defmodule Blogger.PostView do
    use Blogger.Web, :view

    def render("created.json", %{post: post}) do
        %{
            user_id: post.user_id,
            title: post.title,
            body: post.body
        }
    end

    def render("main.json", %{post: post}) do
        %{
            id: post.id,
            user_id: post.user_id,
            title: post.title,
            body: post.body,
            inserted_at: post.inserted_at
        }
    end

    def render("all.json", %{posts: posts}) do
        render_many(posts, __MODULE__, "main.json")
    end

end