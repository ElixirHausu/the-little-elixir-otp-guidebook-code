# Ring

`iex -S mix`

```elixir
iex> pids = Ring.create_processes(5)

iex> Ring.link_processes(pids)

iex> pids |> Enum.map(fn pid -> "#{inspect pid}:
...> #{inspect Process.info(pid, :links)}" end)

["#PID<0.111.0>:\n{:links, [#PID<0.112.0>, #PID<0.115.0>]}",
 "#PID<0.112.0>:\n{:links, [#PID<0.111.0>, #PID<0.113.0>]}",
 "#PID<0.113.0>:\n{:links, [#PID<0.112.0>, #PID<0.114.0>]}",
 "#PID<0.114.0>:\n{:links, [#PID<0.113.0>, #PID<0.115.0>]}",
 "#PID<0.115.0>:\n{:links, [#PID<0.114.0>, #PID<0.111.0>]}"]
```
