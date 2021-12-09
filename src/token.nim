import definitions, strutils, sequtils, sugar

type TokenKind* = enum
  Ident, Operator, Number, MetaToken, Keyword

type Token* = object
  children*: seq[Token]
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


proc `==`*(a, b: Token): bool =
  if a.kind != b.kind: return false

  case a.kind:
  of Ident:
    return a.identValue == b.identValue
  of Operator:
    return a.operatorValue == b.operatorValue
  of Number:
    return a.numberValue == b.numberValue
  of MetaToken:
    return a.metaValue == b.metaValue
  of Keyword:
    a.keywordValue == b.keywordValue
  
proc `==`*(a: Token, b: TokenKind): bool = a.kind == b


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




proc `$`*(t: Token): string {.inline.} =
  result = $t.kind & "("
  case t.kind:
  of Ident:
    result &= t.identValue
  of Operator:
    result &= $t.operatorValue
  of Number:
    result &= $t.numberValue
  of MetaToken:
    result &= '\"' & $t.metaValue & '\"'
  of Keyword:
    result &= $t.keywordValue
  result &= ") " & t.children.map(x => $x).join(",")
