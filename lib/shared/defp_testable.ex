defmodule Shared.DefpTestable do
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
