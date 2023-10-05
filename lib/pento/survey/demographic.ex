defmodule Pento.Survey.Demographic do
  alias Pento.Accounts.User
  use Ecto.Schema
  import Ecto.Changeset

  schema "demographics" do
    field :gender, :string
    field :year_of_birth, :integer
    field :education, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(demographic, attrs) do
    demographic
    |> cast(attrs, [:gender, :year_of_birth, :education, :user_id])
    |> validate_required([:gender, :year_of_birth, :education, :user_id])
    |> validate_inclusion(:gender, ["male", "female", "other", "prefer not to say"])
    |> validate_inclusion(:education, [
      "high school",
      "bachelor's degree",
      "graduate degree",
      "other",
      "prefer not to say"
    ])
    |> validate_inclusion(:year_of_birth, 1900..2022)
    |> unique_constraint(:user_id)
  end
end
