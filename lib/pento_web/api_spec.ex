defmodule PentoWeb.ApiSpec do
  alias OpenApiSpex.SecurityScheme
  alias OpenApiSpex.{Info, OpenApi, Paths, Server, Components}
  alias PentoWeb.{Endpoint, Router}

  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: "Pento API",
        version: "0.1.0"
      },
      paths: Paths.from_router(Router),
      components: %Components{
        securitySchemes: %{
          "authorization" => %SecurityScheme{type: "http", scheme: "bearer"}
        }
      }
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
