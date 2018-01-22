defmodule Metex do
  @moduledoc """
  Documentation for Metex.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Metex.hello
      :world

  """
  def hello do
    :world
  end

  @doc """
  Get temperatures from cities

  ## Examples

      iex> cities = ["Hong Kong", "Shanghai"]
      iex> Metex.temperatures_of(cities)
      :ok

      Hong Kong: 21.9°C, Shanghai: 9.5°C

  """
  def temperatures_of(cities) do
    coordinator_pid = spawn(Metex.Coordinator, :loop, [[], Enum.count(cities)])

    cities
    |> Enum.each(fn city ->
      worker_pid = spawn(Metex.Worker, :loop, [])
      send(worker_pid, {coordinator_pid, city})
    end)
  end
end
