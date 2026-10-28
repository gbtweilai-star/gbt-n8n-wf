#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_n8n_wf info
PYTHONPATH=src python -m gbt_n8n_wf check --payload '{}'
PYTHONPATH=src python -m gbt_n8n_wf run   --payload '{}'
