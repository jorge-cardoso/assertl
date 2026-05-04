import re

from pygments.lexer import RegexLexer, bygroups, include, words
from pygments.token import Text, Keyword, Operator, Punctuation, Number, String


def _build_multi_word_regex(ops):
    ops = sorted(ops, key=len, reverse=True)  
    patterns = []
    for op in ops:
        parts = op.split()
        # join words with flexible whitespace
        patterns.append(r'\s+'.join(map(re.escape, parts)))
    return r'(' + '|'.join(patterns) + r')'


class ASSERTLLexer(RegexLexer):
    """
    Lexer for ASSERTL (nvpass) query language
    """

    flags = re.MULTILINE | re.IGNORECASE

    name = 'ASSERTL'
    aliases = ['assertl']
    filenames = ['*.assertl']

    # -------------------- Keywords --------------------
    QUANTIFIERS = (
        'For All', 'For Any', 'For Each', 'For Some',
        'Exactly One', 'At Least One',
        'For',
        'All', 'Any', 'Each', 'Some',
    )
    QUANTIFIERS = _build_multi_word_regex(QUANTIFIERS)

    LOGICAL = (
        'Or', 'And', 'Also'
    )

    OPERATORS = (
        'Is Not Equal To', 'Does Not Match Pattern', 'Does Not Match',
        'Does Not Contain', 'Contains None Of', 'Is Not Compatible With',
        'Is Greater Than', 'Is Less Than', 'Is At Least', 'Is At Most',
        'Is Older Than', 'Is Newer Than', 'Matches Pattern',
        'Is Compatible With', 'Contains All', 'Has Size Of', 'Length Is',
        'Is One Of', 'Is Among', 'Is Between', 'Is Within',
        'Has Items', 'Includes', 'Contains', 'Matches',
        'Is Not', 'Equals', 'Is'
    )
    OPERATORS = _build_multi_word_regex(OPERATORS)

    EMPTY = (
        'Null', 'None', 'Empty'
    )

    tokens = {
        'root': [
            # -------------------- Comments (optional future extension) --------------------
            (r'#.*$', Text.Comment),

            # -------------------- FULL SLICE EXPRESSIONS (highest priority) --------------------
            (r'\[\s*\d*\s*(\.\.|\:|\-)\s*\d*\s*\]', Operator),            

            # -------------------- Logical connectives --------------------
            (words(LOGICAL, suffix=r'\b'), Keyword),
            (r'\|\||&&', Operator),

            # -------------------- Quantifiers --------------------
            (words(QUANTIFIERS, suffix=r'\b'), Keyword),

            # -------------------- Operators (multi-word first!) --------------------
            (OPERATORS, Keyword),

            # -------------------- Empty -------------------
            (words(EMPTY, suffix=r'\b'), Keyword),

            # fallback short operators
            (r'(==|!=|>=|<=|=|<|>)', Keyword),

            # -------------------- Structural keywords --------------------
            (r'\b(The|Of|In|Where|Unless|Contains|Includes|Matches)\b', Keyword),

            # -------------------- Parentheses / structure --------------------
            (r'[\[\](){}]', Punctuation),
            (r',', Punctuation),

            # -------------------- Range operator (must come before '.') --------------------
            (r'\.\.', Operator),

            (r'\[\s*\d*\s*(\.\.\.|\.\.|\-|:)\s*\d*\s*\]', bygroups(
                Punctuation, Number, Operator, Number, Punctuation
            )),

            # -------------------- Numbers --------------------
            (r'-?\b\d+\.\d+\b', Number.Float),
            (r'-?\b\d+\b', Number.Integer),

            # -------------------- Strings --------------------
            (r'"[^"]*"', String),
            (r"'[^']*'", String),

            # -------------------- Identifiers (property chains, selectors) --------------------
            (r'\b[A-Za-z_][\w\-]*\b', Text),

            # -------------------- Whitespace --------------------
            (r'\s+', Text),
        ]
    }

    def analyse_text(text):
        # Helps Sphinx auto-detect lexer
        score = 0.0
        if 'For All' in text or 'Where' in text:
            score += 0.6
        if 'Is Greater Than' in text or 'Is Less Than' in text:
            score += 0.3
        if 'Unless' in text:
            score += 0.2
        return score


# Register lexer for Sphinx
def setup(app):
    app.add_lexer('assertl', ASSERTLLexer)