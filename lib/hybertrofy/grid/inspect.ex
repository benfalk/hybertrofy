defimpl Inspect, for: Hybertrofy.Grid do
  def inspect(%Hybertrofy.Grid{size: size}, _opts) do
    "%Hybertrofy.Grid<size: #{size}, data: %{...}>"
  end
end
