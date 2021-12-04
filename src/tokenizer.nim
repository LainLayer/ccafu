import options, strutils
import token, definitions, feeder

# TODO: maybe idntlist can be moved to token.nim
var idnlist: seq[string] = @[];

proc `$`(t: Token): string {.inline.} =
  result = $t.kind & "("
  case t.kind:
  of Ident:
    result &= idnlist[cast[int](t.value)]
  of Operator:
    result &= $cast[Operators](t.value)
  of Number:
    result &= $cast[int](t.value)
  of MetaToken:
    result &= $cast[Meta](t.value)
  of Keyword:
    result &= $cast[Keywords](t.value)

  result &= ")"
  

proc parseWord(f: var Feeder): Token {.inline.} =
  var buffer = $f.top()
  while f.hasMore():
    let c = f.next()
    if not (c in IdentChars): break
    buffer.add c
  let attempt = tryKeyword(buffer)
  if attempt.isSome():
    return attempt.get().toToken(f)
  else:
    idnlist.add(buffer)
    return buffer.toToken(idnlist.len - 1, f)


proc parseOperator(f: var Feeder): Token {.inline.} =
  var buffer = $f.top()
  while f.hasMore():
    let c = f.next()
    if not (c in opchars): break
    buffer.add c
  let attempt = tryOperator(buffer)
  if attempt.isSome():
    return attempt.get().toToken(f)
  else:
    assert false, "unexpected operator " & buffer


proc parseNumber(f: var Feeder): Token {.inline.} =
  var buffer = $f.top()
  while f.hasMore():
    let c = f.next()
    if not (c in Digits): break
    buffer.add c
  return buffer.parseInt().toToken(f)
  



proc parse(s: string): seq[Token] =
  var f = s.newFeeder()
  while f.hasMore():
    case f.top():
    of IdentStartChars:
      result.add parseWord(f)
    of opchars:
      result.add parseOperator(f)
    of Digits:
      result.add parseNumber(f)
    of meta:
      result.add f.top().toMeta().toToken(f)
      discard f.next()
    of ws:
      discard f.next()
    else:
      assert(false, "unexpected character '" & f.top() & "'")



# when working with utter crap like Visual Studio Code, which doesnt append
# a newline to the end of the file, we need to add one.
proc pad(s: string): string =
  result = s
  if not s.endsWith('\n'):
    result &= '\n'

proc test*() =
  let text = readFile("test.c").pad()
  let x = parse(text)

  for z in x:
    echo z
  

  