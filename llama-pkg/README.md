# PKGS

Arch Linux package for [llama.cpp](https://github.com/ggml-org/llama.cpp), optimized for **Zen4 + Vulkan**.

## Install

Build and install the package, then set up the config:

```sh
cd llama-pkg
./install
```

Update config only (without rebuilding):

```sh
./install config
```

## Service

Install and start the `llama-server` systemd service:

```sh
sudo ./service install
```

Other commands:

```sh
./service start|stop|status|logs
sudo ./service uninstall
```

The service listens on `0.0.0.0:8080`. On package upgrade, pacman will automatically restart it via the installed hook.

## Models Download

Models are stored in `~/.llama.cpp/models/`:

```sh
hf download unsloth/Qwen3.6-35B-A3B-GGUF Qwen3.6-35B-A3B-UD-IQ3_S.gguf --local-dir ~/.llama.cpp/models
hf download unsloth/gemma-4-26B-A4B-it-GGUF gemma-4-26B-A4B-it-UD-IQ3_S.gguf --local-dir ~/.llama.cpp/models
```

## Benchmark

```sh
llama-bench -m ~/.llama.cpp/models/Qwen3.6-35B-A3B-UD-IQ3_S.gguf -ngl 99
```
