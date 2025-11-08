# Fabric resume determinism breaks with custom samplers in multi‑GPU (loss spike on resume)

## Problem Brief
In multi‑GPU training with Lightning Fabric, resuming from a checkpoint after using a self‑defined (stateful) sampler can cause a sharp increase in training loss and divergence from the pre‑resume trajectory. This violates the expectation that a resumed run should match a continuous run when shuffling and rank/replica‑aware sampling are involved. Deliver a fix that makes resume deterministic and trajectory‑preserving for Fabric with multiple devices when dataloaders use custom samplers, regardless of whether Fabric wraps them with DistributedSampler/DistributedSamplerWrapper.

## Agent Instructions
- Ensure resume reproduces the continuous trajectory:
  - Post‑resume batch ordering per rank must match a continuous run for the next steps (deterministic index parity).
  - Post‑resume losses match continuous run within numeric tolerance.
- Persist and restore all state required for determinism:
  - Model, optimizer(s), LR scheduler(s), global step/epoch.
  - Dataloader progress used to drive sampler shuffling (e.g., per‑loader epoch/counter).
  - Sampler epoch/state when available (e.g., state_dict/load_state_dict or set_epoch).
- Support both cases:
  - A) use_distributed_sampler=True (Fabric wraps/replaces samplers).
  - B) use_distributed_sampler=False (user sampler used directly).
- Maintain correctness for IterableDatasets and non‑shuffling configs; no regressions.
- Keep public API stable; integrate any new state plumbing with existing Fabric save/load paths in a backward‑compatible way.
- Provide deterministic tests that compare “continuous” vs “resume” runs under multi‑process CPU (DDP):
  - Verify parity of batch indices and losses for several steps after resume.
  - Cover shuffle on/off and both A/B sampler paths.

## Test Assumptions (optional)
No new public interfaces required. If adding helper(s) for sampler state persistence, place them under `lightning.fabric.utilities` with conventional naming and imports.
