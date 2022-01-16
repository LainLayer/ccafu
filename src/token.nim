import definitions

type TokenKind* = enum
  Ident     = "identifier",
  Operator  = "operator",
  Number    = "number",
  MetaToken = "token",
  Keyword   = "keyword"

type Token* = object
  row*, col*, size*: int
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


proc isType*(t: Token): bool =
  case t.kind:
  of Keyword:
    return t.keywordValue.isType()
  else:
    return false

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

template `==`*(a: Token, b: TokenKind): bool = a.kind == b


proc token*(s: string): Token {.inline.} =
  Token(kind: Ident, identValue: s)

proc token*(o: Operators): Token {.inline.} =
  Token(kind: Operator, operatorValue: o)

proc token*(n: int): Token {.inline.} =
  Token(kind: Number, numberValue: n)

proc token*(m: Meta): Token {.inline.} =
  Token(kind: MetaToken, metaValue: m)

proc token*(k: Keywords): Token {.inline.} =
  Token(kind: Keyword, keywordValue: k)




proc `$`*(t: Token): string {.inline.} =
  result = $t.kind & " '"
  case t.kind:
  of Ident:
    result &= t.identValue
  of Operator:
    result &= $t.operatorValue
  of Number:
    result &= $t.numberValue
  of MetaToken:
    result &= $t.metaValue
  of Keyword:
    result &= $t.keywordValue
  result &= "'"

proc setLocation*(t: var Token, l: tuple[l, c: int], size: int) =
  t.row = l.l
  t.col = l.c
  t.size = size

proc where*(t: Token): string =
  "row " & $(t.row+1) & ", column " & $(t.col+1)
