
# Git in Devcontainer (git)

Installs Git using the OS package manager with version and update options.

## Example Usage

```json
"features": {
    "ghcr.io/sinhaaritro/devcontainer-feature/git:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Git version to install (e.g., 'latest' or specific version) | string | latest |
| skipUpdate | Skip package manager update to speed up installation | boolean | false |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/sinhaaritro/devcontainer-feature/blob/main/src/git/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
