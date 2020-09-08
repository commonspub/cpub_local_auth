defmodule CommonsPub.LocalAuth.LoginCredential do
  @moduledoc """
  A Mixin that provides a local database login identity, i.e. a
  username/email/etc. and passwowrd.
  """

  use Pointers.Mixin,
    otp_app: :cpub_local_auth,
    source: "cpub_local_auth_login_credential"

  require Pointers.Changesets
  alias CommonsPub.LocalAuth.LoginCredential
  alias Ecto.Changeset
  alias Pointers.Changesets

  mixin_schema do
    field :identity, :string
    field :password, :string, virtual: true
    field :password_hash, :string
  end

  @defaults [
    cast:     [:identity, :password],
    required: [:identity, :password],
  ]

  def changeset(cred \\ %LoginCredential{}, attrs, opts \\ []) do
    Changesets.auto(cred, attrs, opts, @defaults)
    |> Changeset.unique_constraint(:identity)
    |> hash_password()
  end

  def hash_password(%Changeset{valid?: true, changes: %{password: password}}=changeset),
    do: Changeset.change(changeset, Argon2.add_hash(password))
  def hash_password(changeset), do: changeset

end
defmodule CommonsPub.LocalAuth.LoginCredential.Migration do

  import Ecto.Migration
  import Pointers.Migration
  alias CommonsPub.LocalAuth.LoginCredential

  @source LoginCredential.__schema__(:source)

  def migrate_login_credential(index_opts \\ [], dir \\ direction())

  def migrate_login_credential(index_opts, :up) do
    create_mixin_table(LoginCredential) do
      add :identity, :text, null: false
      add :password_hash, :text, null: false
    end
    create_if_not_exists(unique_index(@source, [:identity], index_opts))
  end

  def migrate_login_credential(_index_opts, :down) do
    drop_if_exists(unique_index(@source, [:identity]))
    drop_mixin_table(LoginCredential)
  end

end
