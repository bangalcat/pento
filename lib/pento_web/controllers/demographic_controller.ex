defmodule PentoWeb.DemographicController do
  use PentoWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Pento.Survey
  alias PentoWeb.Schema.DemographicResponse

  action_fallback PentoWeb.FallbackController

  plug OpenApiSpex.Plug.CastAndValidate,
    json_render_error_v2: true,
    replace_params: false

  operation :show,
    summary: "Get demographic by user",
    parameters: [user_id: [in: :path, description: "User ID", type: :integer]],
    security: [%{"authorization" => []}],
    responses: %{
      200 => {"Demographic", "application/json", DemographicResponse}
    }

  def show(conn, _params) do
    params = OpenApiSpex.params(conn) |> dbg()
    demographic = Survey.get_demographic_by_user(%{id: params.user_id})
    render(conn, :show, demographic: demographic)
  end
end
