defmodule PentoWeb.Schema.EmailString do
  use OpenApiSpex.Schemax

  @schema_type :string
  schema do
    min_length 3
    max_length 260
    format :email
  end
end
