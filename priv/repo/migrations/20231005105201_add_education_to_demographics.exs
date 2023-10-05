defmodule Pento.Repo.Migrations.AddEducationToDemographics do
  use Ecto.Migration

  def change do
    alter table("demographics") do
      add :education, :string
    end
  end
end
