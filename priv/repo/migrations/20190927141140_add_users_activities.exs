defmodule Blogger.Repo.Migrations.AddUsersActivities do
    use Ecto.Migration
  
    def change do
      create table(:users_activities) do
        add :user_id, references(:users)
        add :activity_id, references(:activities)
      end
    end
  end
  