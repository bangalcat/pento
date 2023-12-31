defmodule PentoWeb.Presence do
  use Phoenix.Presence, otp_app: :pento, pubsub_server: Pento.PubSub

  @user_activity_topic "user_activity"
  @survey_user_topic "survey_user"

  def track_survey_user(pid, user_email) do
    track(pid, @survey_user_topic, "survey_count", %{users: [%{email: user_email}]})
  end

  def survey_count() do
    list(@survey_user_topic)
    |> get_in(["survey_count", :metas, Access.all(), :users])
    |> then(&(&1 || []))
    |> Enum.uniq()
    |> Enum.count()
  end

  def track_user(pid, product, user_email) do
    track(pid, @user_activity_topic, product.name, %{users: [%{email: user_email}]})
  end

  def list_products_and_users() do
    list(@user_activity_topic)
    |> Enum.map(&extract_product_with_users/1)
  end

  defp extract_product_with_users({product_name, %{metas: metas}}) do
    {product_name, users_from_metas_list(metas)}
  end

  defp users_from_metas_list(metas_list) do
    metas_list
    |> Enum.map(&users_from_meta_map/1)
    |> List.flatten()
    |> Enum.uniq()
  end

  defp users_from_meta_map(%{users: users}) do
    users
  end

  defp users_from_meta_map(_), do: nil
end
