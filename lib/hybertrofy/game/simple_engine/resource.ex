defmodule Hybertrofy.Game.SimpleEngine.Resource do

  defstruct rate: 0, current: 0, max: 0, name: nil

  def new(name), do: %__MODULE__{name: name}

  def new(name, opts) when is_list(opts) do
    %__MODULE__{
      name: name,
      rate: metric(opts, :rate),
      max: metric(opts, :max),
      current: Keyword.get(opts, :current, 0) }
  end

  def add(%__MODULE__{name: name}=r1, %__MODULE__{name: name}=r2) do
    %__MODULE__{
      name: name,
      rate: add_metric(r1.rate, r2.rate),
      current: r1.current + r2.current,
      max: add_metric(r1.max, r2.max)
    }
  end

  def rate(%__MODULE__{rate: rate}, context \\ nil), do: calc_metric(rate, context)

  def max(%__MODULE__{max: max}, context \\ nil), do: calc_metric(max, context)

  def current(%__MODULE__{current: val}) when is_number(val), do: val

  def calculate(%__MODULE__{}=res, context \\ nil) do
    %{ res | rate: rate(res, context), max: __MODULE__.max(res, context) }
  end

  def increment(%__MODULE__{current: val}=res, amount, context \\ nil),
    do: %{ res | current: min(val + amount, __MODULE__.max(res, context)) }

  defp add_metric(:infinity, _), do: :infinity
  defp add_metric(_, :infinity), do: :infinity
  defp add_metric(any, fun) when is_function(fun), do: reduce_metrics([any|[fun]])
  defp add_metric(fun, any) when is_function(fun), do: reduce_metrics([any|[fun]])
  defp add_metric(any, list) when is_list(list), do: reduce_metrics([any|list])
  defp add_metric(list, any) when is_list(list), do: reduce_metrics([any|list])
  defp add_metric(a, b) when is_number(a) and is_number(b), do: a + b

  defp calc_metric(:infinity, _), do: :infinity
  defp calc_metric(metric, _) when is_number(metric), do: metric
  defp calc_metric(metric, val) when is_function(metric), do: metric.(val)
  defp calc_metric(metrics, val) when is_list(metrics),
    do: Enum.reduce(metrics, 0, &add_metric(calc_metric(&1, val), &2))

  defp metric(opts, name) do
    case Keyword.get_values(opts, name) do
      [] -> 0
      [single] -> single
      values -> values
    end
  end

  defp reduce_metrics(metrics) do
    metrics
    |> List.flatten
    |> Enum.reduce({0, []}, fn
      metric, {flat, funs} when is_number(metric) -> {flat+metric, funs}
      fun, {flat, funs} when is_function(fun) -> {flat, [fun|funs]}
    end)
    |> case do
      {flat, []} -> flat
      {0, [fun]} -> fun
      {0, funs} -> funs
      {flat, funs} -> [flat|funs]
    end
  end
end
