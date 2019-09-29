defmodule Blogger.PostController do
    use Blogger.Web, :controller
    alias Blogger.Post
    plug Blogger.Plugs.RequireAuth when action in [:index]
    import Ecto.Query

    def index(conn, _params) do
        render conn, "index.html"
    end

    def all(conn, post) do
        user_id = post["user_id"]
        if user_id do
            user = Repo.get(Blogger.User, user_id)
            if user do
                where = [user_id: user_id]
                order_by = [desc: :inserted_at]
                select = [:id, :title, :body, :user_id, :inserted_at]
                query = from Post,
                        where: ^where,
                        order_by: ^order_by,
                        select: ^select
                posts = Repo.all(query)
                conn
                |> put_status(200)
                |> render("all.json", posts: posts)
            else
                conn
                |> put_status(:not_found)
            end
        else
            conn
            |> put_status(:not_found)
        end
    end

    def update(conn, post) do
        old_post = Repo.get(Post, post["id"])
        changeset = Post.changeset(old_post, post)
        
        case Repo.update(changeset) do
            {:ok, post} ->
                conn 
                |> put_status(200)
                |> render("main.json", post: post)
            {:error, _result} -> 
                conn
                |> put_status(:not_found)

        end
    end

    def delete(conn, post) do
        post = Repo.get(Post, post["id"])
        changeset = Post.changeset(post)
        Repo.delete!(changeset)

        conn
        |> put_status(200)
        |> render("main.json", post: post)
    end

    def create(conn, post) do            

        if post["user_id"] do
            user = Repo.get(Blogger.User, post["user_id"])
            if user do
                changeset = 
                user
                |> build_assoc(:posts)
                |> Post.changeset(post)
                
                case Repo.insert(changeset) do
                    {:ok, post} ->
                        conn
                        |> put_status(201)
                        |> render("created.json", post: post)
                    {:error, _result} ->
                        conn
                        |> put_status(:not_found)
                    
                end
                
            else
                conn
                |> put_status(:not_found)
            end

        else
            conn
            |> put_status(:not_found)
        end

    end
end