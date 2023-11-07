defmodule PentoWeb.Schema.CommonErrorResponse do
  use OpenApiSpex.Schemax

  schema do
    one_of [PentoWeb.Schema.ErrorResponse, legacy_error(), library_error()]
    additional_properties false
  end

  embedded_schema :legacy_error do
    property :errors, detail()
    additional_properties false
  end

  embedded_schema :library_error do
    property :errors, :array, items: detail()
    additional_properties false
  end

  embedded_schema :detail do
    property :detail, :string
  end
end
