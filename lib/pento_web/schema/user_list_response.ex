defmodule PentoWeb.Schema.UserListResponse do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    type: :object,
    required: [:data],
    properties: %{
      data: %Schema{type: :array, items: PentoWeb.Schema.User}
    }
  })
end
