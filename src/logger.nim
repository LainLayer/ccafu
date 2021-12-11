import strformat, strutils
import osproc



type LogLevel* {.pure.} = enum
  err   = 31,
  cmd   = 32,
  warn  = 33,
  debug = 35,
  info  = 36

func paint*(c: int, s: string): string =
  &"\e[{c}m{s}\e[0m"

proc log*(l: static[LogLevel], s: string) {.inline.} =
  const tmp: string = l.int().paint(($l).toupper())
  echo fmt"[{tmp:<14}]: {s}"

{.experimental: "callOperator".}
template `()`*(l: static[LogLevel], s: string) =
  when l == debug:

    # cant print the proc name in release mode
    when (not defined(release)) and defined(debug):
      var name: string
      name = $getFrame().procname & "() "
      l.log($name & s)
    when defined(release) and defined(debug):
      l.log(s)
      
  elif l == cmd:
    let 
      output = execCmdEx(s)
      lines  = output.output.splitLines()

    var
      pr = "$ " & s
      failed: bool = false
    
    if output.exitCode == 0:
      cmd.log(paint(info.int, "SUCCESS") & " " & pr)
    else:
      cmd.log(paint(err.int, "FAILED") & " " & $output.exitCode & " " & pr)
      failed = true
    
    for line in lines:
      if not line.isEmptyOrWhitespace: l.log("> " & line)

    if failed: quit(1)
      
  elif l == err:
    l.log(s)
    quit(1)
  else:
    l.log(s)


when defined(release) and defined(debug):
  # still havent found a way to do that in release
  # not that i think it will be necessary anyway
  info "release build in debug doesnt support showing procedure names"
