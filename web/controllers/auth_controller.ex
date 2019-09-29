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
        if Repo.get_by(User, email: user["email"]) do
            conn
            |> put_flash(:error, "Email Already Exist!")
            |> redirect(to: auth_path(conn, :signup))
        else
            case Repo.insert(changeset) do
                {:ok, _user} ->
                    conn
                    |> put_flash(:info, "You have successfully registerd!")
                    |> redirect(to: auth_path(conn, :index))
                {:error, changeset} -> 
                    conn
                    |> put_flash(:error, "An error occured")
                    |> redirect(to: auth_path(conn, :signup))
            end
        end
    end

    def login(conn, %{"user" => user}) do

        # IO.inspect(user)
        # IO.inspect("+++++++++++")
        # IO.inspect(user_db)
        # IO.inspect("+++++++++++")
        # IO.inspect(Bcrypt.verify_pass(user["password"], user_db.password))

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