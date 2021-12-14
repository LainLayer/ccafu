import strformat, strutils, token

type LogLevel* {.pure.} = enum
  err   = 31,
  cmd   = 32,
  warn  = 33,
  debug = 35,
  info  = 36

when not defined(js):
  import osproc
else:
  import workaround
  proc toColor(l: LogLevel): string =
    return case l:
    of err:   "red"
    of cmd:   "green"
    of warn:  "yellow"
    of debug: "pink"
    else:     "lime"


var loggerText* = ""
  

func paint*(c: int, s: string): string =
  return &"\e[{c}m{s}\e[0m"

proc inFile*(t: Token): seq[string] =
  let s = loggerText.splitLines()
  var ret = s[t.row]
  let sec = ret[t.col-1..<t.col-1+t.size]
  ret[t.col-1..<t.col-1+t.size] = paint(31, sec)
  
  if t.row == 0:
    result = @[ret]
    result.add s[t.row+1..t.row+2]
    
  elif t.row == s.len-1:
    result = s[t.row-2..t.row-1]
    result.add ret
    
  else:
    result = @[s[t.row-1], ret, s[t.row+1]]

proc log*(l: static[LogLevel], s: string) {.inline.} =
  when not defined(js):
    const tmp: string = l.int().paint(($l).toupper())
    echo fmt"[{tmp:<14}]: {s}"
  else:
    const tmp = fmt"[%c{($l).toupper():<5}%c]: "
    jsecho(tmp & s, l.toColor())


{.experimental: "callOperator".}
template `()`*(l: static[LogLevel], s: string, t = Token()) =
  when l == debug:

    # cant print the proc name in release mode
    when (not defined(release)) and defined(debug):
      var name: string
      when defined(js):
        name = ""
      else:
        name = $getFrame().procname & "() "
      l.log($name & s)
    when defined(release) and defined(debug):
      l.log(s)
      
  elif l == cmd and not defined(js):
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
    if t.size != 0:
      for line in t.inFile():
        l.log("> " & line)
    quit(1)
  else:
    l.log(s)


when defined(release) and defined(debug):
  # still havent found a way to do that in release
  # not that i think it will be necessary anyway
  info "release build in debug doesnt support showing procedure names"
