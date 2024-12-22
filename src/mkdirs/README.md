
# Make Directories (mkdirs)

Make directories in the container, owned by specified user (to avoid mounting permission issues)

## Example Usage

```json
"features": {
    "ghcr.io/Duanyll/devcontainer-features/mkdirs:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| directories | Comma-separated list of directories to create. Only the last directory in the path will be assigned the specified user and group. | string | - |
| userid | UID of the user that should own the directories | string | 1000 |
| groupid | GID of the group that should own the directories | string | 1000 |
| mode | Permissions of the directories | string | 755 |

## Typical usage

If you want to mount a volume to a devcontainer at a location that requires creation of parent directories, like the following:

```json
"mounts": [
    // Mount the cache directory to speed up Hugging Face model downloads
    "type=volume,source=hfhub_cache,target=/home/vscode/.cache/huggingface/hub/"
],
```

That may cause `/home/vscode/.cache` and `/home/vscode/.cache/huggingface` have wrong permissions (Owned by root, not vscode) and cause issues when running the container.

To fix this, you can use the `mkdir` feature to create the parent directories before mounting the volume:

```json
"features": [
    "ghcr.io/duanyll/devcontainer-features/mkdir:1": {
        "directories": "/home/vscode/.cache,/home/vscode/.cache/huggingface"
    }
],
"mounts": [
    // Mount the cache directory to speed up Hugging Face model downloads
    "type=volume,source=hfhub_cache,target=/home/vscode/.cache/huggingface/hub/"
],
```

This will create the parent directories with the correct permissions before mounting the volume. However, the mounted volume `hub` still needs to be configured to have the correct permissions outside of the devcontainer. When first running the devcontainer, you may need to run the following command to fix the permissions:

```bash
sudo chown -R 1000:1000 /home/vscode/.cache/huggingface/hub
```

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/Duanyll/devcontainer-features/blob/main/src/mkdirs/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
