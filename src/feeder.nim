type Feeder* = object
  data*: string
  pos*: int
  line*: int
  column*: int
  depth*: int


proc newFeeder*(s: string): Feeder =
  result.data   = s
  result.pos    = 0
  result.line   = 1
  result.column = 1
  result.depth  = 0 # TODO: fix this somehow

proc next*(f: var Feeder): char = 
  inc f.pos
  result = f.data[f.pos]
  if result == '\n':
    f.line += 1
    f.column = 1
  else:
    f.column += 1
  if result in { '(', '{' }:
    f.depth += 1
  if result in { ')', '}' }:
    f.depth -= 1

proc hasMore*(f: Feeder): bool {.inline.} = f.pos < f.data.len-1

proc skipUntil*(f: var Feeder, c: char) {.inline.} =
  while f.hasMore() and f.next() != c:
    discard f.next()

proc top*(f: Feeder): char {.inline.} = f.data[f.pos]