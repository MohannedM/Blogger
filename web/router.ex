defmodule Blogger.Router do
  use Blogger.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Blogger.Plugs.SetUser 
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Blogger do
    pipe_through :browser # Use the default browser stack

    get "/", AuthController, :index


  end

  scope "/api", Blogger do
    pipe_through :api

    post "/posts", PostController, :create
    get "/posts", PostController, :all
    put "/posts/:id", PostController, :update
    delete "/posts/:id", PostController, :delete
  end

  scope "/posts", Blogger do
    pipe_through :browser

    get "/", PostController, :index
    get "/new", PostController, :new
  end

  scope "/auth", Blogger do
    pipe_through :browser # Use the default browser stack

    get "/signup", AuthController, :signup
    post "/saveuser", AuthController, :saveuser
    post "/login", AuthController, :login
    get "/signout", AuthController, :signout

  end

  scope "/activities", Blogger do
    pipe_through :browser

    get "/", ActivityController, :index
    get "/new", ActivityController, :new
    post "/create", ActivityController, :create
    get "/like/:id", ActivityController, :like
    get "/dislike/:id", ActivityController, :dislike
  end

  # Other scopes may use custom stacks.
  # scope "/api", Blogger do
  #   pipe_through :api
  # end
end
