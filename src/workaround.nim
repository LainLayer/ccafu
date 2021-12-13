import std/jsconsole

proc jsecho*(s,c: string) =
  console.log(s, cstring("color: " & c), "")
