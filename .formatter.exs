[
  import_deps: [:ecto, :ecto_sql, :phoenix, :open_api_spex, :open_api_spex_schemax],
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
]
