defmodule Blogger.Repo.Migrations.AddActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :name, :string
      add :description, :string
    end
  end
end
