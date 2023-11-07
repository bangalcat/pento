defmodule PentoWeb.Schema.UserResponse do
  require OpenApiSpex

  OpenApiSpex.schema(%{
    type: :object,
    required: [:data],
    properties: %{
      data: PentoWeb.Schema.User
    },
    example: %{
      data: %{
        id: 1,
        username: "john",
        email: "test@test.com"
      }
    }
  })
end
