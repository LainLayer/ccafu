import options, strutils
import token, definitions, feeder


proc `$`(t: Token): string {.inline.} =
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

  result &= ")"
  

proc parseWord(f: var Feeder): Token {.inline.} =
  var buffer = $f.top()
  while f.hasMore():
    let c = f.next()
    if not (c in IdentChars): break
    buffer.add c
  let attempt = tryKeyword(buffer)
  if attempt.isSome():
    return token attempt.get()
  else:
    return token buffer


proc parseOperator(f: var Feeder): Token {.inline.} =
  var buffer = $f.top()
  while f.hasMore():
    let c = f.next()
    if not (c in opchars): break
    buffer.add c
  let attempt = tryOperator(buffer)
  if attempt.isSome():
    return token attempt.get()
  else:
    assert false, "unexpected operator " & buffer


proc parseNumber(f: var Feeder): Token {.inline.} =
  var buffer = $f.top()
  while f.hasMore():
    let c = f.next()
    if not (c in Digits): break
    buffer.add c
  return token buffer.parseInt()
  



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
      result.add token f.top().toMeta()
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
  

  
