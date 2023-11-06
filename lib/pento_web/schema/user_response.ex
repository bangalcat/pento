defmodule PentoWeb.Schema.UserResponse do
  require OpenApiSpex

  OpenApiSpex.schema(%{
    type: :object,
    required: [:user],
    properties: %{
      user: PentoWeb.Schema.User
    }
  })
end
