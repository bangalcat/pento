defmodule PentoWeb.DemographicLive.Form do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Demographic

  def update(assigns, socket) do
    {:ok, socket |> assign(assigns) |> assign_demographic() |> clear_form()}
  end

  def assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :demographic, %Demographic{user_id: current_user.id})
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def clear_form(%{assigns: %{demographic: demographic}} = socket) do
    assign_form(socket, Survey.change_demographic(demographic))
  end

  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    params = params_with_user_id(demographic_params, socket)
    {:noreply, save_demographic(socket, params)}
  end

  def handle_event("validate", %{"demographic" => demographic_params}, socket) do
    changeset = Survey.change_demographic(socket.assigns.demographic, demographic_params)
    {:noreply, assign_form(socket, changeset)}
  end

  # 함수로 적절히 분리한 케이스. 실제 개발하다보면 함수로 분리할 생각하기 쉽지 않다.
  def params_with_user_id(params, %{assigns: %{current_user: current_user}}) do
    params
    |> Map.put("user_id", current_user.id)
  end

  # our reducer
  defp save_demographic(socket, demographic_params) do
    case Survey.create_demographic(demographic_params) do
      {:ok, demographic} ->
        send(self(), {:created_demographic, demographic})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign_form(socket, changeset)
    end
  end
end
