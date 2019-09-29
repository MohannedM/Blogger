defmodule Blogger.ActivityController do
    use Blogger.Web, :controller
    alias Blogger.Activity
    plug Blogger.Plugs.RequireAuth

    def index(conn, _params) do
        activities = Repo.all(Activity)
        likesArr = Repo.all(Blogger.UserActivity)
        likes = Enum.map(likesArr, fn x -> %{user_id: x.user_id, activity_id: x.activity_id} end)
        user = conn.assigns[:user]
        render conn, "index.html", activities: activities, likes: likes, user: user
    end

    def new(conn, _params) do
        changeset = Activity.changeset(%Activity{})
        render conn, "new.html", changeset: changeset
    end

    def like(conn, %{"id" => activity_id}) do
        activity = Repo.get(Activity, activity_id)
        
        user_id = conn.assigns[:user].id
        changeset = Blogger.UserActivity.changeset(%Blogger.UserActivity{}, %{"user_id" => user_id, "activity_id" => activity_id})
        
        case Repo.insert(changeset) do
            {:ok, _result} -> 
                conn
                |> put_flash(:info, "Activity added to favorities")
                |> redirect(to: activity_path(conn, :index))
            {:error, _result} ->
                conn
                |> put_flash(:info, "Activity added to favorities")
        end

    end

    def dislike(conn, %{"id" => activity_id}) do
        user_id = conn.assigns[:user].id
        if user_id do
            where = [activity_id: activity_id, user_id: user_id]
            query = from Blogger.UserActivity,
                    where: ^where
            [likedActivity] = Repo.all(query)
            Repo.delete!(likedActivity)

            conn
            |> put_flash(:info, "Removed from favorities!")
            |> redirect(to: activity_path(conn, :index))
            
        end
    end

    def create(conn, %{"activity" => activity}) do
        changeset = Activity.changeset(%Activity{}, activity)

        case Repo.insert(changeset) do
            {:ok, _changeset} ->
                conn
                |> put_flash(:info, "Activity was added!")
                |> redirect(to: activity_path(conn, :index))
            {:error, _result} ->
                conn
                |> put_flash(:error, "Sorry an error occured!")
                |> redirect(to: activity_path(conn, :index))
        end
    end
end