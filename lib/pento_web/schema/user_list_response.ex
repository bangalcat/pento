defmodule PentoWeb.Schema.UserListResponse do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    type: :object,
    required: [:data, :cursor, :total],
    properties: %{
      data: %Schema{type: :array, items: PentoWeb.Schema.User},
      cursor: PentoWeb.Schema.Common.Cursor,
      total: %Schema{type: :integer}
    },
    additionalProperties: false
  })
end
