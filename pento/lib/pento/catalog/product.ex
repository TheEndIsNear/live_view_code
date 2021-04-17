defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float

    timestamps()
  end

  @doc false
  def changeset(%{unit_price: current_price} = product, %{price_decrease: price_decrease}) do
    if price_decrease > 0 do
      attrs = %{unit_price: current_price - price_decrease}
      changeset(product, attrs)
    else
      product
      |> changeset(%{})
      |> add_error(:price_decrease, "cannot have a negative price decrease")
    end
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0.0)
  end
end
