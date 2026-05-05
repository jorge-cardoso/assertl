from lark import Lark, Transformer


# ----------------------------
# Parser
# ----------------------------

def build_parser(grammar_file: str):
    with open(grammar_file, "r", encoding="utf-8") as f:
        grammar = f.read()

    return Lark(
        grammar,
        parser="lalr",
        propagate_positions=True
    )


# ----------------------------
# Load statements from text file
# Each statement is separated by a line starting with ---
# ----------------------------

def load_statements(filename: str):
    statements = []
    current = []

    with open(filename, "r", encoding="utf-8") as f:
        for line in f:
            if line.strip().startswith("---"):
                if current:
                    statements.append("".join(current).strip())
                    current = []
            else:
                current.append(line)

    # Add last statement
    if current:
        statements.append("".join(current).strip())

    return [stmt for stmt in statements if stmt]


# ----------------------------
# AST Transformer
# ----------------------------

class ASTTransformer(Transformer):
    def start(self, items):
        return {"type": "program", "body": items}

    def statement_sequence(self, items):
        return {"type": "sequence", "items": items}

    def or_expr(self, items):
        if len(items) == 1:
            return items[0]
        return {"type": "or", "items": items}

    def and_expr(self, items):
        if len(items) == 1:
            return items[0]
        return {"type": "and", "items": items}

    def assertion(self, items):
        node = {
            "type": "assertion",
            "subject": items[0],
            "operator": items[1],
            "value": items[2],
        }
        if len(items) == 4:
            node["unless"] = items[3]
        return node

    def subject(self, items):
        return {"type": "subject", "value": items[-1]}

    def property_chain(self, items):
        return {"type": "property_chain", "items": items}

    def selector(self, items):
        return str(items[0])

    def operator(self, items):
        return str(items[0])

    def value(self, items):
        return items[0]

    def NUMBER(self, token):
        try:
            return int(token)
        except ValueError:
            return float(token)

    def STRING(self, token):
        return str(token)[1:-1]


# ----------------------------
# Public API
# ----------------------------

class AssertlParser:
    def __init__(self, grammar_file="grammar.lark"):
        self._parser = build_parser(grammar_file)
        self._transformer = ASTTransformer()

    def parse(self, text: str):
        tree = self._parser.parse(text)
        return self._transformer.transform(tree)


# ----------------------------
# Example usage
# ----------------------------

if __name__ == "__main__":
    import json

    vp = AssertlParser("assertl.lark")

    # Load statements from file
    examples = load_statements("../samples/examples.asl")

    for idx, example in enumerate(examples, start=1):
        try:
            ast = vp.parse(example)
        except Exception as e:
    
            print("=" * 80)
            print(f"Example {idx}")
            print("-" * 10)
            print(example)
            
            print("PARSE ERROR:")
            print(str(e))