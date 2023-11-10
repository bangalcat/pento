defmodule PentoWeb.Schema.DemographicResponse do
  use OpenApiSpex.Schemax

  schema do
    read_only true
    property :data, PentoWeb.Schema.Demographic
    additional_properties false
  end
end
