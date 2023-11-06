defmodule PentoWeb.Schema.UserListResponse do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    type: :object,
    required: [:users],
    properties: %{
      users: %Schema{type: :array, items: PentoWeb.Schema.User}
    }
  })
end
