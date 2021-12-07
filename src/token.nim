import definitions

type TokenKind* = enum
  Ident, Operator, Number, MetaToken, Keyword

type Token* = object
  case kind*: TokenKind:
  of Ident:
    identValue*: string
  of Operator:
    operatorValue*: Operators
  of Number:
    numberValue*: int
  of MetaToken:
    metaValue*: Meta
  of Keyword:
    keywordValue*: Keywords


proc `token`*(s: string): Token {.inline.} =
  Token(kind: Ident, identValue: s)

proc `token`*(o: Operators): Token {.inline.} =
  Token(kind: Operator, operatorValue: o)

proc `token`*(n: int): Token {.inline.} =
  Token(kind: Number, numberValue: n)

proc `token`*(m: Meta): Token {.inline.} =
  Token(kind: MetaToken, metaValue: m)

proc `token`*(k: Keywords): Token {.inline.} =
  Token(kind: Keyword, keywordValue: k)
