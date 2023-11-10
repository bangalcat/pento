defmodule PentoWeb.Schema.Demographic do
  use OpenApiSpex.Schemax

  schema do
    property :id, :integer
    property :user_id, :integer
    property :gender, :string, enum: ["male", "female", "other", "prefer not to say"]
    property :year_of_birth, :integer, minimum: 1900, maximum: 2022

    property :education, :string,
      enum: [
        "high school",
        "bachelor's degree",
        "graduate degree",
        "other",
        "prefer not to say"
      ]

    property :inserted_at, :integer
    property :updated_at, :integer
    additional_properties false
  end
end
