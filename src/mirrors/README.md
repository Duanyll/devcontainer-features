
# Mirrored Repositories (mirrors)

Use mirrored repositories to speed up package installation

## Example Usage

```json
"features": {
    "ghcr.io/Duanyll/devcontainer-features/mirrors:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| increaseAptRetry | Increase the number of retries for apt-get for poor network connections | boolean | true |
| debian | Debian mirror URL | string | - |
| debianSecurity | Debian security mirror URL (It is not recommended to use a mirror for security updates) | string | - |
| ubuntu | Ubuntu mirror URL | string | - |
| ubuntuSecurity | Ubuntu security mirror URL (It is not recommended to use a mirror for security updates) | string | - |
| alpine | Alpine mirror URL | string | https://dl-cdn.alpinelinux.org/alpine |
| pip | Python pip mirror URL | string | - |

## Typical usage

This feature allows you to use a mirror for apt, apk and pip package managers. It should be installed before the package manager is used. Manually override the feature installation order in `devcontainer.json` to achieve this. 

```json
"overrideFeatureInstallOrder": [
    "ghcr.io/duanyll/devcontainer-features/mirrors:1.1",
    "ghcr.io/devcontainers/features/common-utils:2"
],
```

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/Duanyll/devcontainer-features/blob/main/src/mirrors/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
