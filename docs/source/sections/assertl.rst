

Semantics
------------------

Identifiers and Literals
~~~~~~~~~~~~~~~~~~~~~~~~

To evaluate complex data structures, this DSL distinguishes between **selectors**, **string literals**, and **numeric values**.


**Identifiers & Selectors**
   In this DSL, identifiers such as ``"Load"``, ``"Temperature"``, or ``"Status"`` are always represented as **STRING tokens** enclosed in double quotes.

   According to the grammar, these quoted identifiers function as selectors or property keys when used in expressions.

   - **Selectors:** Quoted strings used to reference fields, keys, or structured data paths.
   - Selectors may be composed using ``Of`` or ``In`` to form property chains.

   Example:

   .. code-block:: assertl

      "Temperature" Is 70
      "Status" Is "Active"
      "Users"[1..10] Where "Status" Is "Active" Has Size Of 5
      "Temperature" Of "Sensor" Of "Node" Is Greater Than 70

**String Literals**
   String literals are also represented using double-quoted strings, but they are interpreted as comparison values rather than selectors.

   Both identifiers and literals share the same lexical form (``STRING``), with meaning determined by position in the expression.

   Example:

   .. code-block:: assertl

      "Status" Is "Active"
      "Name" Is "Server-01"
      "Message" Contains "Error"

**Numeric Literals**
   Numeric values represent scalar magnitudes and are defined by the ``NUMBER`` token.

   They support integers and floating-point values, including negative numbers.

   Example:

   .. code-block:: assertl

      "IB Speed" Is 400
      "Load" Is At Least 90
      "Temperature" Is Greater Than 72.5

**Null Values**
   Null values represent missing or undefined data and are written as ``Null``, ``None``, or ``Empty`` (case-insensitive).

   Example:

   .. code-block:: assertl

      "Status" Is Null
      "Owner" Is None
      "IP" Is Empty



Property Navigation
~~~~~~~~~~~~~~~~~~~

*Used to navigate structured data, nested records, and indexed collections.*


**Property Chains**
    Property chains allow navigation through hierarchical structures using ``Of`` or ``In``.
    According to the grammar, a property chain is composed of one or more selectors linked together.

    .. code-block:: assertl

        "Temp" Of "CPU"[0] Is Less Than 80
        "Firmware" In "OUTPUT" Matches "Major Version 202"
        "Voltage" Of "Sensors"[1] Of "CPU" Is Less Than 3.2

    Each segment of a chain is a full selector, not a raw identifier. A selector is defined as:

    - STRING (quoted identifier)
    - optional index list (``[0]``, ``[1:4]``, ``[0,2]``)
    - optional filter clause (``Where ...``)

**Selectors with Indexing**
    Selectors may include positional or range-based indexing using bracket notation. The grammar supports multiple range syntaxes: ``-``, ``..``, ``...``, and ``:``.

    .. code-block:: assertl

        "Interfaces"[0:4] Is "Up"
        "CPU"[0] Is Compatible With "Driver 123"
        "CPU" Has Size Of 2

    These forms are equivalent in semantics and differ only in syntactic representation.

**Selectors with Filters**
    A selector may be refined using a ``Where`` clause. The filter operates over a full property chain, allowing nested conditions.

    .. code-block:: assertl

        "Fans" Where "Status" Is "Failed" Has Size Of 0
        "Processes" Where "Name" Contains "nv" Has Items [123, 456]
        "Fans" Where "Status" Of "Sensor" Is "Failed" Has Size Of 0


**Additional Valid Examples**
    Additional examples include:

    .. code-block:: assertl

        "CPU"[0] Of "Cluster" Where "Status" Is "Active" Is Compatible With "Driver"
        "Interfaces"[1:3] Where "State" Is "Down" Has Items [1, 2]
        "Temp" Of "CPU"[0] Is Less Than 80


Equality and Magnitude
~~~~~~~~~~~~~~~~~~~~~~

*Defines comparison semantics for equality, inequality, and numeric constraints using both symbolic and natural-language operators.*

**Equality Operators**
    Equality operators evaluate whether a subject matches or differs from a value. The grammar supports both symbolic and natural-language forms, which are lexically equivalent.

    Supported operators include:

    - Natural language: ``Is``, ``Equals``, ``Is Not``, ``Is Not Equal To``
    - Symbolic: ``=``, ``!=``, ``==`` (implementation-dependent aliasing)

    .. code-block:: assertl

        "Architecture" Is "Hopper"
        "Architecture" = "Hopper"
        "Link State" Is Not Equal To "Degraded"
        "Link State" != "Degraded"


**Magnitude and Thresholds**
    Magnitude operators define numeric comparisons and bounded constraints. These are strictly defined in the OPERATOR set and apply only to numeric values (NUMBER).

    Supported operators include:

    - Greater / less comparisons: ``>``, ``<``, ``>=``, ``<=``
    - Natural language equivalents:
        - ``Is Greater Than``
        - ``Is Less Than``
        - ``Is At Least``
        - ``Is At Most``

    .. code-block:: assertl

        "Power Draw" Is Less Than 700
        "VRAM" Is At Least 80000
        "Temperature" >= 85
        "Power Draw" < 700


**Range Semantics**
    The ``Is Between`` operator defines an inclusive numeric interval.

    .. code-block:: assertl

        "Inlet Temp" Is Between [18, 27]
        "Latency" Is Between [1-3]
        "Latency" Is Between [1..3]
        "Latency" Is Between [1:3]        
        "Latency" Is Between [1.2, 3.5]        




Logical Connectives
~~~~~~~~~~~~~~~~~~~

*Defines boolean function semantics for combining expressions. Logical connectives operate at the expression level and follow the grammar rule:*

Logical evaluation follows strict precedence defined by the grammar:

1. Parenthesized expressions ``( expression )``
2. AND-level expressions (``And``, ``Also``, ``&&``)
3. OR-level expressions (``Or``, ``||``)
   

**And / Also / &&**
    AND connectives require that all connected conditions evaluate to true. They operate at the ``and_expression`` level in the grammar.

    Supported tokens:

    - ``And``
    - ``Also``
    - ``&&``

    .. code-block:: assertl

        "Status" Is "Active" And "Speed" Is 400
        "Status" Is "Active" && "Speed" Is 400
        "Status" Is "Active" Also "Speed" Is 400

**Or / Either / ||**
    OR connectives require that at least one connected condition evaluates to true. 
    
    Supported tokens:

    - ``Or``
    - ``Either``
    - ``||``

    .. code-block:: assertl

        "Mode" Is "Auto" Or "Mode" Is "Maximum"
        "Mode" Is "Auto" || "Mode" Is "Maximum"


**Additional Valid Examples**
    Additional examples include:

    .. code-block:: assertl

        ("Status" Is "Active" Or "Status" Is "Idle") And "Speed" >= 400
        "A" Is 1 && "B" Is 2 || "C" Is 3



Negation and Conditional Logic
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Defines exception-based evaluation using conditional inversion semantics. This section aligns with the grammar rule:*


**Unless**
    The ``Unless`` construct introduces an exception condition. The primary assertion is considered true unless the ``unless_clause`` expression evaluates to true, in which case the assertion is invalidated.

    .. code-block:: assertl

        "Throttle Reason" Is "None" Unless "Temp" Is Greater Than 85
        "Link State" Is "Active" Unless "Errors" > 0


**Complex Unless Conditions**
    The ``unless_clause`` supports full expression complexity, including logical connectives and property chains.

    .. code-block:: assertl

        "Throttle" Is "None" Unless "Temp" > 85 Or "Fan" Is "Failed"
        "Service" Is "Running" Unless ("CPU" > 90 And "Mode" Is "Auto")
        "Link" Is "Up" Unless "Errors" > 0 Or "Latency" Is Greater Than 100
        "Mode" Is "Auto" Unless ("Load" > 80 And "Fan" Is "Failed")



Text and Compatibility
~~~~~~~~~~~~~~~~~~~~~~

*Defines string evaluation, pattern matching, and version-aware comparison semantics. This section aligns with the grammar rules for:*

Pattern operators differ from equality operators defined in previous sections:

- ``Is`` / ``Equals`` → strict literal equality
- ``Contains`` / ``Includes`` → substring membership
- ``Matches`` → regex or structured pattern evaluation

.. code-block:: assertl

    "Driver" Is "rdma"
    "Driver" Includes "rdma"
    "Driver" Matches Pattern "rdma.*"


**Pattern Matching**
    Pattern matching evaluates string values against literal substrings or regular expression patterns. The grammar supports both simple inclusion checks and regex-based matching via operator variants.

    Supported operators:

    - ``Includes``
    - ``Contains``
    - ``Matches``
    - ``Matches Pattern``
    - ``Does Not Match``
    - ``Does Not Match Pattern``

    .. code-block:: assertl

        "Message" Includes "loading Kernel Module"
        "Log Line" Contains "ERROR"
        "PCIe Address" Matches Pattern "^0000:\\d{2}:00\\.0$"
        "State" Does Not Match "FAILED"
        "Message" Does Not Match ".*FAILED.*"



**Version Compatibility**
    Version comparison operators evaluate software versions, compatibility constraints, and ordering relationships. These operators extend numeric comparison semantics into structured version strings (e.g., Semantic Versioning or vendor-specific formats).

    Supported operators:

    - ``Is Compatible With``
    - ``Is Not Compatible With``
    - ``Is Newer Than``
    - ``Is Older Than``

    .. code-block:: assertl

        "Driver Version" Is Compatible With "CUDA 12.2"
        "Library" Is Not Compatible With "CUDA 11.8"
        "MOFED" Is Newer Than "5.4-1.0"
        "Kernel" Is Older Than "6.5.0"



Quantified Blocks and Collections
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

*Defines quantified evaluation over grouped statements and collection-based constraints. This section aligns with the grammar rules:*

**Quantifiers**
    Quantifiers apply logical evaluation over groups of statements or selected collections. They define how many elements must satisfy the enclosed expression.

    Supported quantifiers:

    - ``All``, ``For All``
    - ``Any``, ``Any Of``
    - ``Some``
    - ``No``
    - ``Exactly One``
    - ``At Least One``

    .. code-block:: assertl

        For All "CPUs" (
            "Status" Is "Healthy"
            "Temp" < 80
        )

        For All "CPUs" (
            "Temp" < 85 And
            "Status" Is "Healthy"
        )
        
        For Any "CPUs"(
            "Power State" Is "P0"
            "Power State" Is "P1"
        )

        No "Nodes" (
            "Status" Is "Down"
            "Errors" > 0
        )

        At Least One "Interfaces" (
            "State" Is "Up"
        )



**Collection Constraints**
    Supported operators:

    - ``Has Size Of``
    - ``Contains``, ``Includes``, ``Contains All``
    - ``Is One Of``, ``Is Among``

    .. code-block:: assertl

        "Loaded Modules" Has Size Of 8
        "Current Runlevel" Is One Of [3, 5]
        "Devices" Is Among ["NVMe", "USB", "SATA"]
        "Drivers" Contains All ["nvme", "virtio"]


**Nested Quantification**
    Quantified blocks may contain nested logical expressions, including AND/OR connectives and property chains.

    .. code-block:: assertl

        For All "Clusters" (
            Any "Nodes" (
                "Status" Is "Ready"
                "Load" < 80
            )
        )

