defmodule Blogger.AuthControllerTest do
    use Blogger.ConnCase
    alias Blogger.User

    defp create_user(user) do
        hashed_password = Bcrypt.hash_pwd_salt(user["password"])
        user = Map.replace(user, "password", hashed_password) 

        changeset = User.changeset(%User{}, user)  
        Repo.insert!(changeset) 
    end

    describe "POST /login" do
        test "redirects to index if user inputs correct email password combination", %{conn: conn} do

            params = %{
                "name" => "sameh",
                "email" => "sameh@gmail.com",
                "password" => "1234"
            }

  
            
            user = create_user(params)            
            conn = post(conn, auth_path(conn, :login), %{"user" => params})

            assert redirected_to(conn, 302) == auth_path(conn, :index)

        end        
    end

    describe "POST /saveuser" do
        test "Check if user was saved succesfully to the database", %{conn: conn} do
            params = %{
                "name" => "sameh",
                "email" => "sameh@gmail.com",
                "password" => "123456"
            }

            user = create_user(params)
            conn = post(conn, auth_path(conn, :saveuser), %{"user" => params})

            assert redirected_to(conn, 302) == auth_path(conn, :signup)
        end
    end

    describe "GET /signout" do
        test "Check if session is dropped", %{conn: conn} do
            assert conn.assigns[:user_id] == nil
        end
    end



end