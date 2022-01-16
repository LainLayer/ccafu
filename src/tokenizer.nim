import options, strutils
import token, definitions, feeder, logger


proc parseWord(f: var Feeder): Token {.inline.} =
  var
    buffer = $f.top()
    loc = f.location()
  while f.hasMore():
    let c = f.next()
    if not (c in IdentChars): break
    buffer.add c
  let attempt = tryKeyword(buffer)
  if attempt.isSome():
    result = token attempt.get()
    result.setLocation(loc, buffer.len)
  else:
    result = token buffer
    result.setLocation(loc, buffer.len)
  debug $result


proc parseOperator(f: var Feeder): Token {.inline.} =
  var
    buffer = $f.top()
    loc = f.location()
  while f.hasMore():
    let c = f.next()
    if not (c in opchars): break
    buffer.add c
  let attempt = tryOperator(buffer)
  if attempt.isSome():
    result = token attempt.get()
    result.setLocation(loc, buffer.len)
    debug $result
  else:
    err "unexpected operator " & buffer


proc parseNumber(f: var Feeder): Token {.inline.} =
  var
    buffer = $f.top()
    loc = f.location()
  while f.hasMore():
    let c = f.next()
    if not (c in Digits): break
    buffer.add c
  result = token buffer.parseInt()
  result.setLocation(loc, buffer.len)
  debug $result




proc tokenize*(s: string): seq[Token] =
  var f = newFeeder(s)
  f.next()
  while f.hasMore():
    case f.top():
    of IdentStartChars: result.add parseWord(f)
    of opchars: result.add parseOperator(f)
    of Digits: result.add parseNumber(f)
    of meta:
      var t = token f.top().toMeta()
      t.setLocation(f.location(), 1)
      result.add t
      debug $result[result.len - 1]
      f.next()
    of ws:
      f.next()
    else:
      err "unexpected character '" & f.top() & "'"





