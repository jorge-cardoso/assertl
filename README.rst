Project Structure
=================

Creating a new Domain Specific Language (DSL) with a unified developer experience requires syncing two different "worlds": the **VS Code (TextMate/Tree-sitter)** ecosystem and the **Python (Pygments)** ecosystem used by Sphinx.

To avoid writing your grammar twice (and having them drift apart), the best strategy is to use **Tree-sitter** for the heavy lifting.


Highlighting
------------

Historically, people wrote TextMate grammars (`.tmLanguage.json`). However, for a new DSL in 2026, **Tree-sitter** is the industry standard because it provides a real AST (Abstract Syntax Tree), which is faster and more powerful for features like "Go to Definition" or "Refactor."

| Feature | VS Code / Cursor | Sphinx Docs |
| :--- | :--- | :--- |
| **Engine** | VS Code built-in or `tree-sitter-vscode` | `pygments-tree-sitter` or Custom Lexer |
| **Input** | `grammar.js` (Tree-sitter) | Same `grammar.js` |
| **Result** | High-perf semantic highlighting | Precise HTML/CSS highlighting |



Project Structure
-----------------

Since you are hosting on GitHub and using GitHub Pages for Sphinx, a **Monorepo** structure is best. This keeps your language logic, extension code, and documentation in one place.

.. code-block:: text

    my-dsl-repo/
    ├── .github/workflows/      # CI/CD for Git Pages and Extension publishing
    ├── core/                   # Shared logic (if any)
    ├── tree-sitter-mydsl/      # The Tree-sitter grammar (Single source of truth)
    │   ├── grammar.js
    │   └── src/                # Generated C/WASM files
    ├── extension/              # VS Code / Cursor Extension
    │   ├── src/
    │   ├── package.json
    │   └── syntaxes/           # Links to Tree-sitter or a compiled .json
    ├── docs/                   # Sphinx Documentation
    │   ├── conf.py             # Sphinx config
    │   ├── index.rst
    │   └── _ext/               # Custom Pygments lexer for your DSL
    └── samples/                # Example .mydsl files (for testing & docs)




Implementation
--------------

Build the Tree-sitter Grammar
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Start here. This defines how your language is parsed.
1. Initialize a tree-sitter project in `/tree-sitter-mydsl`.
2. Define your rules in `grammar.js`.
3. Generate the parser: `tree-sitter generate`.

Create the VS Code Extension
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

1. Use `yo code` to scaffold a new extension.
2. Instead of a complex regex TextMate file, use the [Tree-sitter VS Code API](https://code.visualstudio.com/api/language-extensions/syntax-highlight-guide#semantic-highlighting).
3. If you want a quick start, you can use the `tree-sitter-vscode` extension to bridge your grammar into the editor.

Sphinx & Pygments Integration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Sphinx uses **Pygments** for highlighting. To make Sphinx "see" your new DSL:
1. **The Quick Way:** Write a simple Regex-based Pygments Lexer in your `docs/conf.py`.
2. **The Professional Way:** Use a bridge like `pygments-tree-sitter`. This allows Pygments to use the same `grammar.js` you built for VS Code.

In your `docs/conf.py`, you will register the language:

.. code-block:: python

    # docs/conf.py
    import sys
    import os
    sys.path.insert(0, os.path.abspath('_ext'))

    extensions = ['mydsl_lexer'] # A small python script to map your lexer


Automation & Deployment
~~~~~~~~~~~~~~~~~~~~~~~

*   **GitHub Actions:** Create a workflow that triggers on every push to `main`.
*   **Docs:** Use `sphinx-build` to generate HTML and push it to the `gh-pages` branch.
*   **Extension:** Use `vsce` (VS Code Extension Manager) to package and optionally publish to the Marketplace or Open VSX so Cursor can find it.

> **Pro Tip:** In your Sphinx docs, use the `.. literalinclude::` directive to pull in files from your `/samples` folder. This ensures that the code examples in your documentation are always valid and up-to-date with your actual language development.

How complex is the syntax of your DSL? (e.g., is it indentation-based like Python or bracket-based like C?)