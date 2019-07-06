# Elevio Wrapper

For pulling all dependencies and compiling:

```shell
$ make local-compile
```


For running test cases:

```shell
$ vim .env
export ELEVIO_API_KEY="<api-key>"
export ELEVIO_TOKEN="<token>"
$ source .env
$ mix test
```


For creating a release:

```shell
$ make local-release
```


To build docker image:

```shell
$ make docker-build
```


To run docker image:

```shell
$ vim config/docker.env # Set env vars
$ make docker-run
```

------

Once the application is started, you can query the server using different endpoints.
If 'PORT' is set to 4000, then you can use [http://localhost:4000](http://localhost:4000)

| Title | Endpoint | Query params |
|-------|----------|--------------|
| List all articles    | `/elevio/articles` | ?page_number=&lt;integer&gt; |
| | | ?page_size=&lt;integer&gt;|
| Get article by id | `/elevio/article/<id>` | |
| Search article | `/elevio/search/<lang_code>` | ?query=&lt;search term&gt; |

------

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/elevio_wrapper](https://hexdocs.pm/elevio_wrapper).

