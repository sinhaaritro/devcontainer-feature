
# Neovim in Devcontainer (neovim)

Installs Neovim on Debian-based images using git.

## Example Usage

```json
"features": {
    "ghcr.io/sinhaaritro/devcontainer-feature/neovim:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Neovim version to install (e.g., '0.10.0' or 'latest') | string | latest |
| skipUpdate | Skip running apt-get update before installation (default: false) | boolean | false |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/sinhaaritro/devcontainer-feature/blob/main/src/neovim/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
