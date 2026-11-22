# Building the NEXORA live ISO

## Supported build host

Use a clean Ubuntu 24.04 LTS (Noble) AMD64 machine with a working internet connection, at least 4 CPU cores, 8 GB RAM, and 30 GB free disk space. A larger disk is recommended. The build script installs packages with APT and requires root privileges (it uses sudo when available).

## Build locally

```bash
git clone https://github.com/ravaunrichards/Nexora_English_64.git
cd Nexora_English_64
git switch nexora/development
bash scripts/check-source.sh
bash scripts/build-iso.sh
```

The script creates `build/nexora-live-build/live-image-amd64.hybrid.iso` and prints its SHA-256 digest. It deletes and recreates only that dedicated build directory. Do not run it if you have irreplaceable files in that directory.

## Build with GitHub Actions

Open the repository's Actions tab, choose **NEXORA live ISO**, select **Run workflow**, and start the manual build. Download the `nexora-live-iso` artifact when the workflow completes successfully.

## Build design

The configuration uses Ubuntu Noble archives and Ubuntu kernel packages through live-build. Package lists and filesystem overlays are version-controlled under `nexora-linux/config/`.

A successful CI job proves only that the build command produced an ISO on that runner. It does not prove that the ISO boots on every machine, that Wi-Fi/audio/GPU drivers work, or that installation to disk is supported.
