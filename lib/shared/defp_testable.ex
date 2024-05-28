defmodule Shared.DefpTestable do
  @moduledoc """
  This macro is used to become private functions testable
  this way we don't have to define the functions public
  to do doctests.
  """
  defmacro defp_testable(head, body \\ nil) do
    if Mix.env() == :test do
      quote do
        def unquote(head) do
          unquote(body[:do])
        end
      end
    else
      quote do
        Module.delete_attribute(__MODULE__, :doc)

        defp unquote(head) do
          unquote(body[:do])
        end
      end
    end
  end
end
