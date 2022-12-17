enabled_tools = [
  {:compiler, "mix compile --warnings-as-errors --all-warnings", env: %{"MIX_ENV" => "test"}},
  {:credo, "mix credo suggest --all --checks-without-tag ci_ignore"},
  {:dialyzer, true},
  {:ex_unit, true},
  {:formatter, true},
  {:unused_deps, true}
]

disabled_tools = Enum.map(~w[doctor ex_doc sobelow]a, &{&1, false})

[
  tools: enabled_tools ++ disabled_tools
]
