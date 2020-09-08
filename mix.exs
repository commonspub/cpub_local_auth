defmodule CommonsPub.LocalAuth.MixProject do
  use Mix.Project

  def project do
    [
      app: :cpub_local_auth,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: "Local Auth-related models for commonspub",
      homepage_url: "https://github.com/commonspub/cpub_local_auth",
      source_url: "https://github.com/commonspub/cpub_local_auth",
      package: [
        licenses: ["MPL 2.0"],
        links: %{
          "Repository" => "https://github.com/commonspub/cpub_local_auth",
          "Hexdocs" => "https://hexdocs.pm/cpub_local_auth",
        },
      ],
      docs: [
        main: "readme", # The first page to display from the docs 
        extras: ["README.md"], # extra pages to include
      ],
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:argon2_elixir, "~> 2.3.0"},
      {:pointers, "~> 0.5.1"},
      # {:pointers, git: "https://github.com/commonspub/pointers", branch: "main"},
      # {:pointers, path: "../pointers", override: true},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
    ]
  end
end
