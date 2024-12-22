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