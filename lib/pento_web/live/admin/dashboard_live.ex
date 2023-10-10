defmodule PentoWeb.Admin.DashboardLive do
  use PentoWeb, :live_view

  alias PentoWeb.Endpoint
  alias PentoWeb.Admin.SurveyResultsLive
  alias PentoWeb.Admin.UserActivityLive
  alias PentoWeb.Admin.SurveyCountLive
  @survey_results_topic "survey_results"
  @user_activity_topic "user_activity"
  @survey_user_toipc "survey_user"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
      Endpoint.subscribe(@user_activity_topic)
      Endpoint.subscribe(@survey_user_toipc)
    end

    {:ok,
     socket
     |> assign(:survey_results_component_id, "survey-results")
     |> assign(:user_activity_component_id, "user-activity")
     |> assign(:survey_count_component_id, "survey-count")}
  end

  def handle_info(%{event: "rating_created"}, socket) do
    send_update(SurveyResultsLive, id: socket.assigns.survey_results_component_id)
    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff", topic: topic}, socket) do
    send_update_component(topic, socket)

    {:noreply, socket}
  end

  defp send_update_component(topic, socket) do
    case topic do
      @user_activity_topic ->
        send_update(UserActivityLive, id: socket.assigns.user_activity_component_id)

      @survey_user_toipc ->
        send_update(SurveyCountLive, id: socket.assigns.survey_count_component_id)
    end
  end
end
