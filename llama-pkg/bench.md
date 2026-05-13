# Benchmarking

Use this command to run a quick local benchmark for a selected GGUF model.

Prerequisites:

- `llama-cpp` package installed and `llama-bench` available in `PATH`
- Model file exists under your local models directory

```sh
llama-bench -m ~/.llama.cpp/models/Qwen3.6-35B-A3B-UD-IQ3_S.gguf -ngl 99
```

Notes:

- `-ngl 99` attempts to offload most layers to GPU.
- Adjust model path and offload value for your hardware.
