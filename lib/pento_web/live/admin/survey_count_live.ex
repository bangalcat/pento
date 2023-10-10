defmodule PentoWeb.Admin.SurveyCountLive do
  use PentoWeb, :live_component

  alias PentoWeb.Presence

  def update(_assigns, socket) do
    {:ok, socket |> assign_survey_count()}
  end

  def assign_survey_count(socket) do
    count = Presence.survey_count()

    assign(socket, :survey_count, count)
  end
end
