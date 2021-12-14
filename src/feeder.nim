type Feeder* = object
  data*: string
  pos*: int
  line*: int
  column*: int

proc newFeeder*(s: string): Feeder {.inline.} =
  result.data   = s
  result.pos    = -1 # in case code starts with one new line
  result.line   = 0
  result.column = 0

proc next*(f: var Feeder): char = 
  inc f.pos
  result = f.data[f.pos]
  if result == '\n':
    f.line += 1
    f.column = 0
  else:
    f.column += 1

proc hasMore*(f: Feeder): bool {.inline.} = f.pos < f.data.len-1

proc skipUntil*(f: var Feeder, c: char) {.inline.} =
  while f.hasMore() and f.next() != c:
    discard f.next()

proc top*(f: Feeder): char {.inline.} = f.data[f.pos]

proc location*(f: Feeder): tuple[l: int, c: int] = (f.line, f.column)
