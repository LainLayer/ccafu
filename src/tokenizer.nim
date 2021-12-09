import options, strutils
import token, definitions, feeder, logger


proc parseWord(f: var Feeder): Token {.inline.} =
  var buffer = $f.top()
  while f.hasMore():
    let c = f.next()
    if not (c in IdentChars): break
    buffer.add c
  let attempt = tryKeyword(buffer)
  if attempt.isSome():
    result = token attempt.get()
  else:
    result = token buffer
  debug $result


proc parseOperator(f: var Feeder): Token {.inline.} =
  var buffer = $f.top()
  while f.hasMore():
    let c = f.next()
    if not (c in opchars): break
    buffer.add c
  let attempt = tryOperator(buffer)
  if attempt.isSome():
    result = token attempt.get()
    debug $result
  else:
    err "unexpected operator " & buffer


proc parseNumber(f: var Feeder): Token {.inline.} =
  var buffer = $f.top()
  while f.hasMore():
    let c = f.next()
    if not (c in Digits): break
    buffer.add c
  result = token buffer.parseInt()
  debug $result
  



proc tokenize*(s: string): seq[Token] =
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
      debug $result[ result.len - 1 ]
      discard f.next()
    of ws:
      discard f.next()
    else:
      err "unexpected character '" & f.top() & "'"



# when working with utter crap like Visual Studio Code, which doesnt append
# a newline to the end of the file, we need to add one.
proc pad(s: string): string {.inline.} =
  result = s
  if not s.endsWith('\n'):
    result &= '\n'


  
