Integration
===========

VS-Code / Cursor
----------------


- :download:`ASSERTL for VS Code <assertl_vscode.abc>`.

Create a VSCode extension scaffold:

.. code-block:: bash

    npm install -g yo generator-code
    yo code

Choose: 1) New Extension (TypeScript or JavaScript)

Create the TextMate grammar (`assertl.tmLanguage.json`)
You convert your **Lark grammar** into **VS Code TextMate grammar** using Gemini.

Register your language in `package.json`:

.. code-block:: json    

    "publisher": "local",
    ...
    "contributes": {
        "languages": [
        {
            "id": "assertl",
            "aliases": [
            "assertl",
            "AssertL"
            ],
            "extensions": [
            ".asl"
            ]
        }
        ],
        "grammars": [
        {
            "language": "assertl",
            "scopeName": "source.assertl",
            "path": "./assertl.tmLanguage.json"
        },
        {
            "scopeName": "source.assertl.rst.injection",
            "path": "./assertl-injection.tmLanguage.json",
            "injectTo": ["source.rst", "text.restructuredtext"]
        }
        ]
    },
    
Language configuration (optional but important) `language-configuration.json`.
This defines brackets, comments, auto-closing, etc.

.. code-block:: json    

    {
        "comments": {
            "lineComment": "//"
        },
        "brackets": [
            ["(", ")"],
            ["[", "]"]
        ],
        "autoClosingPairs": [
            { "open": "(", "close": ")" },
            { "open": "[", "close": "]" },
            { "open": "\"", "close": "\"" }
        ],
        "surroundingPairs": [
            { "open": "(", "close": ")" },
            { "open": "\"", "close": "\"" }
        ]
    }


Create injection grammar `assertl.tmLanguage.json`:

.. code-block:: json    


    {
    "scopeName": "source.assertl",
    "scopeNameComment": "source.assertl",
    "name": "AssertL",
    "patterns": [
        { "include": "#keywords" },
        { "include": "#operators" },
        { "include": "#connectives" },
        { "include": "#numbers" },
        { "include": "#strings" },
        { "include": "#punctuation" }
    ],
    "repository": {
        "keywords": {
        "patterns": [
            {
            "name": "keyword.control.assertl",
            "match": "\\b(For|All|Any|Some|Each|No|Exactly One|At Least One|The|Unless|Where|Of|In|Null|None|Empty)\\b"
            }
        ]
        },
    ...


Create injection grammar `assertl-injection.tmLanguage.json`:abbr:

.. code-block:: json    


    {
    "scopeName": "source.assertl.rst.injection",
    "injectionSelector": "L:source.rst -comment, L:text.restructuredtext -comment",  
    "patterns": [
        {
        "begin": "(?i)^(\\s*)(\\.\\.\\s+code-block::)\\s+(assertl)\\b",
        "beginCaptures": {
            "2": { "name": "keyword.other.directive.restructuredtext" },
            "3": { "name": "variable.parameter.restructuredtext" }
        },
        "end": "^(?=\\s{0,\\1}\\S)",
        "contentName": "source.assertl",
        "patterns": [
            { "include": "source.assertl" }
        ]
        }
    ]
    }

Run:

.. code-block:: bash

    npm install -g @vscode/vsce
    npm install --save-dev typescript
    # In MacOs: ⌘ + ⇧ + P: Shell Command: Install 'code' command in PATH

    # For each modification, update the version in package.json (e.g., 0.0.1 → 0.0.2)
    # Package extension
    vsce package --allow-missing-repository 
    # This produces: assertl-0.0.1.vsix

    # Edit the README.md file

    # Install
    code --install-extension assertl-0.0.1.vsix

    # Developer: Reload Window
    # In MacOs: ⌘ + ⇧ + P: Developer: Reload Window


.. code-block:: assertl

    "Loaded Modules"[1:3] Has Size Of 8
    "Current Runlevel" Is One Of [3, 5]
    "Devices" Is Among ["NVMe", "USB", "SATA"]
    "Drivers" Contains All ["nvme", "virtio"]        
    For All "Clusters" (
        Any "Nodes" (
            "Status" Is "Ready"
            "Load" Is Less Than 80
        )
    )



Sphinx / Pygments
----------------

- :download:`ASSERTL for Sphinx <assertl_conf.py>`.

  Add the following code to conf.py to integrate ASSERTL into Sphinx:

  .. code-block:: python

    sys.path.insert(0, str(Path(__file__).resolve().parent / "assertl"))
    from assertl_conf import setup as setup_assertl

    def setup(app):
        setup_assertl(app)
