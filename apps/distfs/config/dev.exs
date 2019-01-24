use Mix.Config

config :syringe, injector_strategy: AliasInjectingStrategy

config :distfs, :filesystem_root, "/tmp"