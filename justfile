flake := env('FLAKE', justfile_directory()) 
rebuild := if os() == "macos" { "sudo darwin-rebuild" } else { "nixos-rebuild" }
system-args := if os() != "macos" { "--sudo --no-reexec" } else { "" }

[private]
default:
    @just --list

[group('rebuild')]
[private]
builder goal *args:
    {{ rebuild }} {{ goal }} \
      --flake {{ flake }} \
      {{ system-args }} \
      {{ args }}

[group('rebuild')]
switch *args: (builder "switch" args)

[group('rebuild')]
deploy host *args: (builder "switch" "--target-host " + host "--use-substitutes " + args)

[group('rebuild')]
provision host:
  nix run github:nix-community/nixos-anywhere -- \
    --flake {{ flake }} \
    --target-host {{ host }}

[group('rebuild')]
[macos]
setup host:
  sudo nix run github:nix-darwin/nix-darwin -- switch --flake {{ flake }}#{{ host }}

[group('utils')]
clean:
    nix-collect-garbage --delete-older-than 7d
    nix store optimise

[group('utils')]
rotate:
  /usr/bin/find secrets/ -name "*.yaml" | xargs -I {} sops rotate -i {}
  /usr/bin/find secrets/ -name "*.yaml" | xargs -I {} sops updatekeys -y {}

[group('utils')]
update:
  nix flake update \
    --commit-lock-file \
    --commit-lockfile-summary "flake: update inputs" \
    --flake {{ flake }}

alias fix := repair

[group('utils')]
repair:
  nix-store --verify --check-contents --repair
