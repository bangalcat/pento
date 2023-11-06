defmodule PentoWeb.Schema.ErrorResponse do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    type: :object,
    description: "Common Error response",
    required: [:error],
    properties: %{
      error: %Schema{
        type: :object,
        required: [:code, :message],
        properties: %{
          code: %Schema{type: :integer},
          message: %Schema{type: :string}
        }
      }
    }
  })
end
