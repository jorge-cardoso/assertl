# AssertL

**AssertL** (Semantic Assertion and Validation Language) is a domain-specific language for expressing validation rules over structured data and command output in a natural-language–influenced style. It is designed for human readability and for **LLM-assisted interpretation**: a semi-formal specification layer with flexible semantics rather than a strictly deterministic execution grammar.

This VS Code extension adds **syntax highlighting** for AssertL in standalone `.asl` files and **injects** AssertL highlighting inside `.. code-block:: assertl` regions in ReStructuredText (`.rst`).

## What AssertL is for

- Validating tool or API output against expected structure, ranges, and text patterns.
- Writing assertions with **quoted selectors** (`"Temperature"`, `"Status"`), **property chains** (`"Temp" Of "CPU"[0]`), and **quantified blocks** (`For All`, `For Each`, `In`).
- Combining conditions with **And** / **Or** (and symbolic `&&` / `||`), **Unless** for exceptions, and operators for equality, magnitude, ranges, patterns, and version compatibility.

AssertL tolerates ambiguity by design: the same surface syntax can support multiple consistent interpretations depending on context—useful for LLM-driven workflows; strict parsers should follow the project grammar and docs.

## Language snapshot

Selectors and literals use double-quoted strings; meaning follows position in the expression.

```assertl
"Status" Is "Active"
"Power Draw" Is Less Than 700
"Temperature" Of "Sensor" Of "Node" Is Greater Than 70

For All "Core[0-4]" In "Sensors" (
    "Temperature" Is Less Than 80
)

"Throttle Reason" Is "None" Unless "Temp" Is Greater Than 85
```

Range notations such as `[1-3]`, `[1..3]`, and `[1:3]` are treated as equivalent conceptual ranges. Null-like values may be written as `Null`, `None`, or `Empty` (case-insensitive).

## Extension features

| Feature | Description |
|--------|-------------|
| **Language ID** | `assertl` (aliases: assertl, AssertL) |
| **File extension** | `.asl` |
| **RST integration** | Grammar injection into `source.rst` / `text.restructuredtext` so `.. code-block:: assertl` blocks are highlighted |
| **TextMate scopes** | `source.assertl` and `source.assertl.rst.injection` |

## Requirements

- [Visual Studio Code](https://code.visualstudio.com/) (or a compatible editor) matching `engines.vscode` in `package.json`.

No runtime interpreter is bundled; this extension focuses on **editing and readability**.

## Related documentation

The `.vsix` contains only the editor support files (grammar, language config). The **language specification** and reference parser are not bundled; they live next to this extension in a full **local checkout** of the book:

- `assertl.rst` — semantics, operators, quantifiers, examples (same folder name as this DSL: `.../co-ops/assertl/assertl.rst`).
- `parser.py` — reference parser in that same `assertl` folder.

## Local install

From this folder, build and install without any remote repository:

1. `npm install`
2. `npx @vscode/vsce package --allow-missing-repository` — produces `assertl-x.y.z.vsix` (flag avoids the “missing repository” warning for local-only extensions)
3. In VS Code: **Extensions** → `...` → **Install from VSIX...** and choose the file.

## Known issues

- Highlighting follows TextMate rules; edge cases in nested RST or mixed fences may differ slightly from the reference `parser.py` in your local book sources.

## Release notes

### 0.0.5

Current development line; see `package.json` for the exact version.

### Earlier

Packaged as `.vsix` for local install.

---

**AssertL** is part of the ai-infra-operations documentation and tooling set for infrastructure validation workflows.
