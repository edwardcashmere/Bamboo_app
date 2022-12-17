defmodule BambooApp.CommonSchema do
  @moduledoc """
  encapsulate all related imports and macros reused in schemas
  """
  import Ecto.Changeset

  defmacro __using__(_opts \\ []) do
    quote do
      use Ecto.Schema
      import __MODULE__
       @type t() :: %__MODULE__{}
    end
  end

  @spec format_string_fields(Ecto.Changeset.t(), atom(), (any -> any)) :: Ecto.Changeset.t()
  def format_string_fields(%Ecto.Changeset{valid?: true} = changeset, field, format_func) when is_atom(field) and is_function(format_func) do
    field = get_change(changeset, field)

    if field do
      put_change(changeset, :name, format_func.(field))
    else
      changeset
    end
  end

  def format_string_fields(changeset, _, _) do
    changeset
  end


end
