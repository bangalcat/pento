defmodule PentoWeb.Schema.UserParams do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    type: :object,
    required: [:user],
    properties: %{
      user: %Schema{
        type: :object,
        required: [:username, :email, :password],
        properties: %{
          username: %Schema{type: :string, maxLength: 30},
          email: PentoWeb.Schema.EmailString,
          password: %Schema{type: :string, minLength: 4, maxLength: 72}
        }
      }
    }
  })
end
