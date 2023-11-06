defmodule PentoWeb.Schema.UserUpdateParams do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    type: :object,
    required: [:username],
    properties: %{
      username: %Schema{type: :string}
    }
  })
end
