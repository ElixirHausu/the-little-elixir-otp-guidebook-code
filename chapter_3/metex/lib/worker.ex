defmodule Metex.Worker do
  def loop do
    receive do
      {sender_pid, location} ->
        send(sender_pid, {:ok, temperature_of(location)})

      _ ->
        IO.puts("don't know how to process this message")
    end

    loop()
  end

  def temperature_of(location) do
    result = location |> url_for |> HTTPoison.get() |> parse_resp

    case result do
      {:ok, temp} ->
        "#{location}: #{temp}°C"

      :error ->
        "#{location} not found"
    end
  end

  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apiKey()}"
  end

  defp parse_resp({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body |> JSON.decode!() |> compute_temperature
  end

  defp parse_resp(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp apiKey do
    Application.get_env(:metex, :api_key)
  end
end
