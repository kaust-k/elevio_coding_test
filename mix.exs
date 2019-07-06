defmodule ElevioWrapper.MixProject do
  use Mix.Project

  def project do
    [
      app: :elevio_wrapper,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Elevio Wrapper",
      source_url: "https://github.com/kaust-k/PROJECT",
      homepage_url: "http://YOUR_PROJECT_HOMEPAGE",
      docs: [
        # The main page in the docs
        main: "readme",
        # logo: "path/to/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ElevioWrapper.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:distillery, "~> 2.1"},
      {:httpoison, "~> 1.5"},
      {:poison, "~> 3.1"},
      {:plug_cowboy, "~> 2.0"},
      {:bypass, "~> 1.0", only: :test},
      {:ex_doc, "~> 0.20", only: :dev, runtime: false}
    ]
  end
end
