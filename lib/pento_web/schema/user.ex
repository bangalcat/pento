defmodule PentoWeb.Schema.User do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    type: :object,
    required: [:id, :username],
    properties: %{
      id: %Schema{type: :integer},
      username: %Schema{type: :string},
      email: PentoWeb.Schema.EmailString
    },
    additionalProperties: false
  })
end
