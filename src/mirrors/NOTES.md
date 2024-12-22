## Typical usage

This feature allows you to use a mirror for apt, apk and pip package managers. It should be installed before the package manager is used. Manually override the feature installation order in `devcontainer.json` to achieve this. 

```json
"overrideFeatureInstallOrder": [
    "ghcr.io/duanyll/devcontainer-features/mirrors:1.1",
    "ghcr.io/devcontainers/features/common-utils:2"
],
```