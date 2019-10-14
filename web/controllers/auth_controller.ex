defmodule Blogger.AuthController do
    use Blogger.Web, :controller
    alias Blogger.User

    def index(conn, _params) do
        order_by = [desc: :inserted_at]
        select = [:id, :title, :body, :user_id, :inserted_at]
        query = from Blogger.Post,
                order_by: ^order_by,
                select: ^select
        posts = Repo.all(query)
        changeset = User.changeset(%User{}, %{})
        render conn, "index.html", changeset: changeset, posts: posts
    end

    def signup(conn, _params) do
        changeset = User.changeset(%User{}, %{})
        render conn, "signup.html", changeset: changeset
    end

    def saveuser(conn, %{"user" => user}) do
        password = user["password"]
        hashed_password = Bcrypt.hash_pwd_salt(password)
        user = Map.replace(user, "password", hashed_password) 

        changeset = User.changeset(%User{}, user)
        with user when is_nil(user) <- Repo.get_by(User, email: user["email"]),
        {:ok, user} <- Repo.insert(changeset) do
            conn
            |> put_flash(:info, "You have successfully registerd!")
            |> redirect(to: auth_path(conn, :index))
        
        else
            %User{} ->
                conn
                |> put_flash(:error, "Email Already Exist!")
                |> redirect(to: auth_path(conn, :signup))
            {:error, changeset} ->
                conn
                |> put_flash(:error, "An error occured")
                |> redirect(to: auth_path(conn, :signup))
        end  

    end

    def login(conn, %{"user" => user}) do

        with %{id: id, password: password} <- Repo.get_by(User, email: user["email"])
        do
            with true <- Bcrypt.verify_pass(user["password"], password) do
                conn
                |> put_session(:user_id, id)   
                |> put_flash(:info, "Welcome back!")
                |> redirect(to: auth_path(conn, :index))
            else
                false ->
                    conn
                    |> put_flash(:error, "Password is incorrect")
                    |> redirect(to: auth_path(conn, :index))
            end
        else
        nil ->
            conn
            |> put_flash(:error, "Email does not exist!")
            |> redirect(to: auth_path(conn, :index))
        end
    end

    def signout(conn, _params) do
        conn
        |> configure_session(drop: true)
        |> redirect(to: auth_path(conn, :index))
    end

end