import definitions, feeder

const SIZE = sizeof(int)

type TokenKind* = enum
  Ident, Operator, Number, MetaToken, Keyword

type Token* = object
  kind*: TokenKind
  line*, column*, depth*: int
  value*: array[SIZE, uint8]

proc toToken*(k: Keywords, f: Feeder): Token =
  Token(
    kind: Keyword,
    line: f.line, column: f.column,
    depth: f.depth,
    value: cast[array[SIZE, uint8]](k)
  )

proc toToken*(o: Operators, f: Feeder): Token =
  Token(
    kind: Operator,
    line: f.line, column: f.column,
    depth: f.depth,
    value: cast[array[SIZE, uint8]](o)
  )

proc toToken*(m: Meta, f: Feeder): Token =
  Token(
    kind: MetaToken,
    line: f.line, column: f.column,
    depth: f.depth,
    value: cast[array[SIZE, uint8]](m)
  )

proc toToken*(n: int, f: Feeder): Token =
  Token(
    kind: Number,
    line: f.line, column: f.column,
    depth: f.depth,
    value: cast[array[SIZE, uint8]](n)
  )

proc toToken*(s: string, i: int, f: Feeder): Token =
  Token(
    kind: Ident,
    line: f.line, column: f.column,
    depth: f.depth,
    value: cast[array[SIZE, uint8]](i)
  )


# for unimpletemened tokens
# TODO: remove this
proc emptyToken*(): Token =
  Token(
    kind: Ident,
    line: 0, column: 0,
    value: cast[array[SIZE, uint8]](0)
  )