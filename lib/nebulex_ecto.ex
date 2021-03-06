defmodule Nebulex.Ecto do
  @moduledoc """
  `Nebulex.Ecto` is composed by a single main module: `Nebulex.Ecto.Repo`,
  which is the wrapper on top of `Nebulex.Cache` and `Ecto.Repo`.

  ## Cacheable Repo

  Suppose you have an Ecto repo and a Nebulex cache separately:

      defmodule MyApp.Cache do
        use Nebulex.Cache, otp_app: :my_app
      end

      defmodule MyApp.Repo do
        use Ecto.Repo, otp_app: :my_app
      end

  The idea is to encapsulate both in a single module using `Nebulex.Ecto.Repo`,
  like:

      defmodule MyApp.CacheableRepo do
        use Nebulex.Ecto.Repo, otp_app: :my_app
      end

  Configuration would be like this:

      config :my_app, MyApp.CacheableRepo,
        cache: MyApp.Cache,
        repo: MyApp.Repo

      config :my_app, MyApp.Cache,
        adapter: Nebulex.Adapters.Local

      config :my_app, MyApp.Repo,
        adapter: Ecto.Adapters.Postgres,
        database: "ecto_simple",
        username: "postgres",
        password: "postgres",
        hostname: "localhost"

  Now we can use `MyApp.CacheableRepo` as a regular Ecto repo, of course,
  there are some constraints, `Nebulex.Ecto.Repo` only provides some of
  the `Ecto.Repo` functions (the basic ones – get, get_by, insert, update,
  delete, etc.), please check them out before.

  Usage example:

      schema = %MyApp.MySchema{x: "abc"}

      {:ok, schema} = MyApp.CacheableRepo.insert(schema)

      MyApp.CacheableRepo.get!(MyApp.MySchema, schema.id)

      MyApp.CacheableRepo.get_by!(MyApp.MySchema, [id: schema.id])

      changeset = Ecto.Changeset.change schema, x: "New"
      {:ok, schema} = MyApp.CacheableRepo.update(changeset)

      MyApp.CacheableRepo.delete(schema)
  """
end
