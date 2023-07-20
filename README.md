# bump.fish

Dirty little fish function that saves you 5 seconds of your time by bumping the
version of an Elixir project in `mix.exs`, `README.md` and `CHANGELOG.md` all
at once.

## Assumptions

- The version in `mix.exs` is assigned to a module attribute (e.g.
  `@version "0.1.0"`).
- `README.md` has installation instructions for adding the mix dependency
  (e.g. `{:my_library, "~> 0.1.0}`).
- The changelog uses the [keep a changelog](https://keepachangelog.com) format
  and has an `## Unreleased` header.

## Installation

```bash
curl -o ~/.config/fish/functions/bump.fish https://raw.githubusercontent.com/woylie/bump.fish/main/bump.fish
```

## Usage

Change into the directory of your Elixir/Mix project and type:

```bash
bump patch
bump minor
bump major
```

## Alternative

Use the mix task [bumper](https://github.com/woylie/bumper) to do the same.
