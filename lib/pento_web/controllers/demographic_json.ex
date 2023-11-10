defmodule PentoWeb.DemographicJSON do
  alias Pento.Survey.Demographic

  def show(%{demographic: demographic}) do
    %{data: demographic(demographic)}
  end

  def demographic(%Demographic{} = demographic) do
    %{
      demographic
      | inserted_at: DateTime.to_unix(demographic.inserted_at),
        updated_at: DateTime.to_unix(demographic.updated_at)
    }
  end
end
