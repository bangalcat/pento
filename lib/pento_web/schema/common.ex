defmodule PentoWeb.Schema.Common do
  defmodule Cursor do
    use OpenApiSpex.Schemax
    alias OpenApiSpex.Cast

    @schema_type :string
    schema "Cursor" do
      description "Base64 encoded Cursor for pagination"
      format :byte
      default nil
      example "Y3Vyc29yOjE="
      validate __MODULE__
    end

    def cast(%Cast{value: nil} = context), do: Cast.ok(context)

    def cast(%Cast{value: value} = context) when is_binary(value) do
      case Base.decode64(value) do
        {:ok, "cursor:" <> cursor} -> Cast.ok(%{context | value: String.to_integer(cursor)})
        _ -> Cast.error(context, {:invalid_type, :base64})
      end
    end

    def cast(ctx), do: Cast.error(ctx, {:invalid_type, :string})
  end

  defmodule PageSize do
    use OpenApiSpex.Schemax

    @schema_type :integer
    schema "PageSize" do
      description "Number of items per page"
      minimum 1
      maximum 100
      default 10
    end
  end
end
