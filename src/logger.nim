import strformat, strutils, osproc

type LogLevel* {.pure.} = enum
  err   = 31,
  cmd   = 32,
  warn  = 33,
  debug = 35,
  info  = 36

func paint*(c: int, s: string): string {.compileTime.} =
  &"\e[{c}m{s}\e[0m"

proc log*(l: static[LogLevel], s: string) {.inline.} = 
  const tmp: string = l.int().paint(($l).toupper())
  echo fmt"[{tmp:<14}]: {s}"

{.experimental: "callOperator".}
proc `()`*(l: static[LogLevel], s: string) =
  case l:
  of debug:
    # TODO: workaround
    # var name = getFrame().procname
    if defined(debug): l.log(s)
  of cmd:
    l.log("$ " & s)
    let output = execCmdEx(s)
    for row in output.output.strip().split('\n'):
      if not row.isEmptyOrWhitespace: l.log("> " & row)
    l.log("returned status: " & $(output.exitCode))
  of err:
    l.log(s)
    quit(1)
  else:
    l.log(s)
