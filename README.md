# Contacts SH

Contacts challenge!

## Run locally

1. Create/Migrate database:

```shell
mix ecto.create
mix ecto.migrate
```

2. Run server:

```
iex -S mix phx.server
```

You can access the swagger page at [http://localhost:4000/](http://localhost:4000/) to test the endpoints.

## Erlang Release

To launch the release, run the following commands:

1. Create database:

```
MIX_ENV=prod mix ecto.create
MIX_ENV=prod mix ecto.migrate
```

2. Build release and launch:

```
MIX_ENV=prod mix release
PORT=4000 _build/prod/rel/contacts_sh/bin/contacts_sh start
```

You can access the swagger page at [http://localhost:4000/](http://localhost:4000/) to test the endpoints.
