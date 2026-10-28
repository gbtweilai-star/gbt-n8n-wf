# n8n_wf

**One capability bit from GBT V8, packaged standalone.** No. 2 of 341,
`automation` domain (Automation).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> n8n 工作流控制（我们自己的自托管 n8n 2.30·数据在 ~/.n8n）：status/list 只读直连；export/import/active/hook 过 filesystem_write 门；hook 可 POST /webhook/gbt 触发 n8n 工作流——「N8N 有的我们都有」的双向桥（n8n→能力网关 已导桥接工作流，框架→n8n 由本能力位负责）

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-n8n-wf.git
cd gbt-n8n-wf
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_n8n_wf info                  # capability card
python -m gbt_n8n_wf spec --json           # machine-readable contract
python -m gbt_n8n_wf check --payload '{}'
python -m gbt_n8n_wf run   --payload '{}'
```

Real `info` output from this machine:

```text
n8n_wf  (automation)  v1.0.0
----------------------------------------
n8n 工作流控制（我们自己的自托管 n8n 2.30·数据在 ~/.n8n）：status/list 只读直连；export/import/active/hook 过 filesystem_write 门；hook 可 POST /webhook/gbt 触发 n8n 工作流——「N8N 有的我们都有」的双向桥（n8n→能力网关 已导桥接工作流，框架→n8n 由本能力位负责）

gated      : True   <- needs explicit consent
external   : False
multi-op   : True
params     : (none)
values     : export, import, active, hook
```

Wire a real implementation:

```python
from gbt_n8n_wf import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（4 个）**：`export`、`import`、`active`、`hook`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Gated: this bit is marked `safe: false` in the registry — it can change state that no inverse action restores.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.14s
```

## Provenance

| field | value |
|---|---|
| capability | `n8n_wf` |
| domain | `automation` |
| handler | `n8n_wf` |
| safe | `False` (gated = `True`) |
| external | `False` |
| atlas page | [automation/n8n_wf](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/automation/n8n_wf.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
