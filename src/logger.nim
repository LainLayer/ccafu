import strformat, strutils, token, terminal
var loggerText* = ""


type Color* = enum  
  Black   = 30
  Red     = 31
  Green   = 32
  Yellow  = 33
  Blue    = 34
  Magenta = 35
  Cyan    = 36
  White   = 37

type LineOfCode = object
  text: string
  real: int
  row:  int

func makeLOC(t: string, rl: int, r: int): LineOfCode =
  let tc = t.count('\t')
  if tc > 0:
    return LineOfCode(text: t.replace("\t", "    "), real: rl + 4*tc - tc, row: r+1)
  else:
    return LineOfCode(text: t, real: rl, row: r+1)

{.experimental: "callOperator".}
func `()`*(c: Color, s: string): string = &"\e[{c.int}m{s}\e[0m"
    
func prepareMessage(s: string, side: int): seq[string] =
  let
    lw    = side*2 + 5
    words = s.split()
    
  var
    buff: seq[string] = @[]
    loc    = 0
    length = 0

  template push() =
    let line = buff.join(" ")
    result.add line & spaces(lw - line.len)
    length = 0
    buff = @[]

  while loc < words.len:
    let current = words[loc]
    if length + current.len >= lw:
      push()
    else:
      buff.add current
      length += current.len + 1
    inc loc

  push()


func prepareLine(s: LineOfCode, space: int): string =
  return s.text & spaces(space - s.real)

proc errorBox(s: string, code: seq[LineOfCode]): string =
  let
    tw   = terminalWidth()
    side = (tw - 10) shr 1
    tag  = Red("Error")

  # top bar
  result  = spaces(side)               &    "┌───────┐" & spaces(side)         &  '\n'
  result &= "┌" & "─".repeat(side - 1) & fmt"┤ {tag} ├" & "─".repeat(side - 1) & "┐\n" 
  result &= "│" & ' '.repeat(side - 1) &    "└───────┘" & ' '.repeat(side - 1) & "│\n"

  # insert error message
  for line in prepareMessage(s, side):
    result &= "│ " & line & " │\n"

  # close off error message
  result &= "├" & "─".repeat(5) & "┬" & "─".repeat(side*2 + 1) & "┤\n"

  # location in code
  for l in code:
    result &= fmt"│{l.row:>4} │ " & prepareLine(l, side*2) & "│\n"

  result &= "└" & "─".repeat(5) & "┴" & "─".repeat(side*2 + 1) & "┘"


template debug*(s: string) =
  # print debug message if enabled
  when defined(debug):
    echo Magenta("debug"), " - ", s



proc inFile*(t: Token): seq[LineOfCode] =
  let s = loggerText.splitLines()
  var ret = s[t.row]
  let l   = ret.len
  let sec = ret[t.col-1..<t.col-1+t.size]
  ret[t.col-1..<t.col-1+t.size] = Red(sec)

  let target = makeLOC(ret, l, t.row)
  
  if t.row == 0:
    result = @[target]
    result.add makeLOC(s[t.row+1], s[t.row+1].len, t.row+1)
    result.add makeLOC(s[t.row+2], s[t.row+2].len, t.row+2)
    
  elif t.row == s.len-1:
    result.add makeLOC(s[t.row-2], s[t.row-2].len, t.row-2)
    result.add makeLOC(s[t.row-1], s[t.row-1].len, t.row-1)
    result.add target
    
  else:
    result.add makeLOC(s[t.row-1], s[t.row-1].len, t.row-1)
    result.add target    
    result.add makeLOC(s[t.row+1], s[t.row+1].len, t.row+1)

proc err*(s: string, tk = Token()) =
  # error message handling
  
  if tk.size != 0:
    echo errorBox(s, inFile(tk))

  quit(1)

proc info*(s: string) =
  echo Green("info"), " - ", s
