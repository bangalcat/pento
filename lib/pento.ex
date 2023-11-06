defmodule Pento do
  use Boundary,
    deps: [Ecto, Ecto.Changeset],
    exports: [{Accounts, []}, {Catalog, []}, {Game, []}, {Promo, []}, {Survey, []}, Repo]

  @moduledoc """
  Pento keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
end
