defmodule PentoWeb.Schema.Category do
  use OpenApiSpex.Schemax

  @schema_type :string
  schema do
    enum ["Arcade", "Survival", "RPG", "Simulation"]
  end
end
