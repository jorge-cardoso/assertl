.. AssertL documentation master file, created by
   sphinx-quickstart on Mon May  4 20:06:23 2026.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

ASSERTL: Semantic Assertion and Validation Language
===================================================

Overview
--------

This document defines **ASSERTL (Semantic Assertion and Validation Language)**, a domain-specific language (DSL) designed to evaluate system tool outputs against structured data.

ASSERTL provides a **natural-language–influenced assertion syntax** for expressing validation rules in a way that is both human-readable and semantically consistent for large language model (LLM) interpretation. Rather than functioning as a strictly deterministic parsing grammar, ASSERTL is intended as a **semi-formal specification layer** that guides LLM reasoning through structured patterns and semantic heuristics.

The language prioritizes **interpretability and robustness over strict formal precision**, allowing flexible expression of validation logic across diverse data formats.

ASSERTL is a complete declarative query language and works as a contract. You provide the criteria, and the verification engine guarantees it will find the data and verify the result. It is a complete query language because it allows for Selection (identifiers), Filtering (where), Quantification (for each/some), and Validation (assertions).

Example
~~~~~~~

The following example demonstrates how ASSERTL can be used to validate the output of the `sensors` command, which reports CPU temperatures and other hardware sensor data.

.. code-block:: bash

    $ sensors


The output may look like this:

.. code-block:: bash

    coretemp-isa-0000
    Adapter: ISA adapter
    Package id 0:  +34.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 0:        +31.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 1:        +31.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 2:        +33.0°C  (high = +100.0°C, crit = +100.0°C)
    Core 3:        +29.0°C  (high = +100.0°C, crit = +100.0°C)

    pch_cannonlake-virtual-0
    Adapter: Virtual device
    temp1:        +31.0°C  

    BAT0-acpi-0
    Adapter: ACPI interface
    in0:           8.62 V  

    iwlwifi_1-virtual-0
    Adapter: Virtual device
    temp1:        +32.0°C  

    nvme-pci-0100
    Adapter: PCI adapter
    Composite:    +26.9°C  (low  = -20.1°C, high = +77.8°C)
                          (crit = +81.8°C)
    Sensor 1:     +26.9°C  (low  = -273.1°C, high = +65261.8°C)

    acpitz-acpi-0
    Adapter: ACPI interface
    temp1:        +27.8°C  


ASSERTL allows us to express validation rules for this output in a natural-language style. For example:

.. code-block:: assertl

    For All "Core[0-4]" In "Sensors" (
        "Temperature" Is Less Than 80
    )

    "Core" Has Size Of 4

    For Each "Adaptor" In ["coretemp-isa-0000", "pch_cannonlake-virtual-0"] (
        "Temp1" Is Less Than 80
    )

    "Voltage" Of "in0" Of "BAT0-acpi-0" Is Less Than 12.0


Design Philosophy
~~~~~~~~~~~~~~~~~~

ASSERTL is designed as a **natural-language executable specification layer** for LLM-driven reasoning and validation. Its key characteristics are:

- Ambiguity tolerance: multiple valid interpretations may coexist if semantically consistent.
- Redundancy as reinforcement: repeated or alternative expressions strengthen intent.
- Natural-language operators are first-class constructs.
- Synonym diversity improves robustness across model distributions.

This enables:

- Partial pattern matching
- Fuzzy semantic grounding
- Context-driven disambiguation

Semantic Behavior
~~~~~~~~~~~~~~~~~

ASSERTL supports soft semantic mapping. For example:

.. code-block:: assertl

    "Status" Is "Active"

may be interpreted as equality, predicate evaluation, or filtering depending on context.

Range expressions:

- [1-3]
- [1..3]
- [1:3]

are treated as equivalent conceptual ranges.

Limitations and Risks
~~~~~~~~~~~~~~~~~~~~~

The main risk is semantic collision. For example:

.. code-block:: assertl

    "Status" Is "Active"

may map to multiple interpretations (equality, predicate, or filter). Consistent interpretation depends on context and prompt framing.

Related Languages
~~~~~~~~~~~~~~~~~

ASSERTL is similar in spirit to:

- Gherkin (Cucumber): readable but scenario-driven; ASSERTL is assertion-driven.
- Robot Framework: readable and keyword-driven; however, ASSERTL is LLM-interpreted and semantically flexible, while Robot Framework is deterministic.

ASSERTL is designed for **probabilistic interpretation by language models**, not strict execution engines.




Add your content using ``reStructuredText`` syntax. See the
`reStructuredText <https://www.sphinx-doc.org/en/master/usage/restructuredtext/index.html>`_
documentation for details.

This Sphinx_ theme was designed to provide a great reader experience for
documentation users on both desktop and mobile devices. This theme is commonly
used with projects on `Read the Docs`_ but can work with any Sphinx project.

.. _Sphinx: http://www.sphinx-doc.org
.. _Read the Docs: http://www.readthedocs.org

Using this theme
----------------

:doc:`sections/assertl`
    How to install this theme on your Sphinx project.


.. toctree::
   :maxdepth: 2
   :caption: Contents:

   sections/assertl
   sections/ebnf_parser
   sections/examples
   sections/integration
