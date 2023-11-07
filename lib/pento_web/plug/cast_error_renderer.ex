defmodule PentoWeb.Plug.CastErrorRenderer do
  @moduledoc """

  This is Error Renderer plug for `OpenApiSpex.Plug.CastAndValidate` plug

  The `init/1` callback isn't invoked at compile time like other plugs.
  Instead, the `call/2` is invoked immediately after `init/1` is invoked
  with the result(errors) returned from `init/1`.


  Example of errors from `OpenApiSpex.Plug.CastAndValidate`.

  ```elixir
  [
    %OpenApiSpex.Cast.Error{
      format: nil,
      length: 0,
      meta: %{},
      name: nil,
      path: [:user_id],
      reason: :invalid_type,
      type: :integer,
      value: "wrong"
    }
  ]
  ```

  다음은 에러 타입의 종류

  ```elixir
    @type reason ::
          :all_of
          | :any_of
          | :invalid_schema_type
          | :exclusive_max
          | :exclusive_min
          | :invalid_discriminator_value
          | :invalid_enum
          | :invalid_format
          | :invalid_type
          | :max_items
          | :max_length
          | :max_properties
          | :maximum
          | :min_items
          | :min_length
          | :minimum
          | :missing_field
          | :missing_header
          | :invalid_header
          | :multiple_of
          | :no_value_for_discriminator
          | :null_value
          | :one_of
          | :unexpected_field
          | :unique_items

  ```

  """

  @behaviour Plug

  alias Plug.Conn
  alias OpenApiSpex.Cast.Error
  require Logger

  @impl Plug
  def init(errors) do
    errors
    |> debug_log_errors()
    |> Enum.reduce({:invalid_parameter, "invalid_parameter"}, &reduce_error/2)
  end

  @impl Plug
  def call(
        %Conn{
          private: %{
            open_api_spex: %{
              spec_module: spec_module
            }
          }
        } = conn,
        {code, message}
      ) do
    # NOTE: 컴파일 의존성을 줄이기 위해 module을 직접 참조하지 않고 string으로 분리
    mod_name = Module.split(spec_module) |> List.last()
    do_call(conn, mod_name, {code, message})
  end

  def call(conn, _errors), do: conn

  defp do_call(conn, "ApiSpec", {code, message}) do
    response = %{error: %{code: code, message: message}}

    json = Jason.encode!(response)

    conn
    |> Conn.put_resp_header("content-type", "application/json")
    |> Conn.send_resp(400, json)
  end

  defp reduce_error(
         %Error{reason: :invalid_type, path: path, type: type, value: value},
         {r, _}
       )
       when r != :missing_parameter do
    {:invalid_parameter,
     "#{inspect(path)} is invalid. expect type: #{inspect(type)}, actual: #{inspect(value)}"}
  end

  # NOTE: 파라미터가 nested 구조이고 nested한 데이터 일부가 없는 경우 invalid_parameter로 취급
  defp reduce_error(%Error{reason: :missing_field, path: [_, _ | _] = path}, {r, _})
       when r != :missing_parameter do
    {:invalid_parameter, "#{inspect(path)} is missing"}
  end

  defp reduce_error(%Error{reason: :missing_field, path: path}, {r, _})
       when r != :missing_parameter do
    {:missing_parameter, "#{inspect(path)} is missing"}
  end

  defp reduce_error(%Error{reason: :invalid_header, value: value, name: name}, _) do
    {:invalid_parameter, "header `#{name}: #{inspect(value)}` is invalid"}
  end

  defp reduce_error(_, err_tuple), do: err_tuple

  defp debug_log_errors(errors) do
    Logger.debug("[OpenApiSpex] cast and validate errors: #{inspect(errors)}")
    errors
  end
end
