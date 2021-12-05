import definitions, feeder

const SIZE = sizeof(int)

type TokenKind* = enum
  Ident, Operator, Number, MetaToken, Keyword

type Token* = object
  kind*: TokenKind
  line*, column*, depth*: int
  value*: array[SIZE, uint8]

# in general for this mess, might wanna use this:
# https://forum.nim-lang.org/t/4496
# type
#   CKind* = enum Int, String
  
#   C* = object
#     case kind*: CKind:
#     of Int:
#       i*: int
#     of String:
#       text*: string

# var b = C(kind: Int, i: 0)
# var a = C(kind: String, text: "")
# TODO: check this

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


# possibly make this bunch of functions generic somehow
# unlikely


# proc toToken*(a: auto, f: Feeder): Token =
#   Token(
#     kind: Ident,
#     line: f.line, column: f.column,
#     depth: f.depth,
#     value: cast[array[SIZE, uint8]](a)
#   )

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