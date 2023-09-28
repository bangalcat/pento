defmodule Pento.Catalog.Faq do
  use Ecto.Schema
  import Ecto.Changeset

  schema "faqs" do
    field :question, :string
    field :answer, :string
    field :vote, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(faq, attrs) do
    faq
    |> cast(attrs, [:question, :answer, :vote])
    |> validate_required([:question, :answer, :vote])
  end

  def create_changeset(faq, attrs) do
    faq
    |> cast(attrs, [:question, :answer])
    |> validate_required([:question, :answer])
  end

  def upvote_changeset(faq, attrs) do
    faq
    |> cast(attrs, [:vote])
    |> validate_required([:vote])
    |> validate_number(:vote, greater_than: faq.vote)
  end
end
