#!/bin/bash
set -euo pipefail

case "${1:-}" in
  base)
    # Run a stable subset of existing tests that should pass at base commit
    pytest -q tests/tests_fabric/test_fabric.py::test_setup_dataloaders_distributed_sampler_parity
    ;;
  new)
    # Run newly added tests (expected to fail at base commit before the fix)
    pytest -q tests/tests_fabric/test_resume_custom_sampler.py
    ;;
  *)
    echo "Usage: ./test.sh {base|new}" >&2
    exit 1
    ;;
esac
