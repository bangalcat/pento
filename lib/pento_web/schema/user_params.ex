defmodule PentoWeb.Schema.UserParams do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    type: :object,
    required: [:username, :email, :password],
    properties: %{
      username: %Schema{type: :string},
      email: %Schema{type: :string},
      password: %Schema{type: :string}
    }
  })
end
