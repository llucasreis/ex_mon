defmodule ExMon.Trainer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "trainers" do
    field :name, :string
    field :password_hash
    field :password, :string, virtual: true
    timestamps()
  end

  @required_params [:name, :password]

  def build(params) do
    params
    |> changeset()
    |> apply_action(:insert)
  end

  # def changeset(params), do: create_changeset(%__MODULE__{}, params)
  # def changeset(trainer, params), do: create_changeset(trainer, params)

  def changeset(trainer \\ %__MODULE__{}, params) do
    trainer
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
