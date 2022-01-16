import options, std/setutils, strutils

#  _  _______   ____      _____  ___ ___  ___ 
# | |/ / __\ \ / /\ \    / / _ \| _ \   \/ __|
# | ' <| _| \ V /  \ \/\/ / (_) |   / |) \__ \
# |_|\_\___| |_|    \_/\_/ \___/|_|_\___/|___/
                                            
# TODO: maybe use this later, probably not
# const keychars* = keywords.join().items.toSet()

type Keywords* = enum
  Auto     = "auto"    , Break    = "break"   , Case     = "case"    , Char     = "char"    ,
  Const    = "const"   , Continue = "continue", Default  = "default" , Do       = "do"      ,
  Double   = "double"  , Else     = "else"    , Enum     = "enum"    , Extern   = "extern"  ,
  Float    = "float"   , For      = "for"     , Goto     = "goto"    , If       = "if"      ,
  Inline   = "inline"  , Int      = "int"     , Long     = "long"    , Register = "register",
  Restrict = "restrict", Return   = "return"  , Short    = "short"   , Signed   = "signed"  ,
  Sizeof   = "sizeof"  , Static   = "static"  , Struct   = "struct"  , Switch   = "switch"  ,
  Typedef  = "typedef" , Union    = "union"   , Unsigned = "unsigned", Void     = "void"    ,
  Volatile = "volatile", While    = "while"   


proc isType*(k: Keywords): bool =
  case k:
  of Int, Float, Double, Void, Char:
    return true
  else:
    return false

proc tryKeyword*(s: string): Option[Keywords] =
  try: return some(parseEnum[Keywords](s))
  except ValueError: discard

# TODO: get rid of this
proc isTypeKeyword*(k: Keywords): bool =
  case k:
  of Int, Float, Char, Double:
    return true
  else:
    return false


#   ___  ___ ___ ___    _ _____ ___  ___  ___ 
#  / _ \| _ \ __| _ \  /_\_   _/ _ \| _ \/ __|
# | (_) |  _/ _||   / / _ \| || (_) |   /\__ \
#  \___/|_| |___|_|_\/_/ \_\_| \___/|_|_\|___/
                                            


type Operators* = enum
  Not      = "!" , NotEqual    = "!=", Modulus       = "%" , ModulusEqual = "%=", And            = "&"  , AndAnd          = "&&" ,
  AndEqual = "&=", Multiply    = "*" , MultiplyEqual = "*=", Plus         = "+" , PlusPlus       = "++" , PlusEqual       = "+=" ,
  Minus    = "-" , MinusMinus  = "--", MinusEqual    = "-=", Arrow        = "->", ArrowStar      = "->*", Dot             = "."  ,
  Divide   = "/" , DivideEqual = "/=", Less          = "<" , ShiftLeft    = "<<", ShiftLeftEqual = "<<=", SmallerEqual    = "<=" ,
  Equal    = "=" , EqualEqual  = "==", Greater       = ">" , GreaterEqual = ">=", ShiftRight     = ">>" , ShiftRightEqual = ">>=",
  Xor      = "^" , XorEqual    = "^=", Or            = "|" , OrEqual      = "|=", OrOr           = "||" , Destroy         = "~"  


proc makeOpChars(): set[char] {.compileTime.} = 
  var buff = ""
  for key in Operators:
    buff &= $key
  return buff.join().items.toSet()

const opchars* = makeOpChars()

proc tryOperator*(s: string): Option[Operators] =
  try: return some(parseEnum[Operators](s))
  except ValueError: discard

  
#  __  __ ___ _____ _      ___ _  _   _   ___    _   ___ _____ ___ ___  ___ 
# |  \/  | __|_   _/_\    / __| || | /_\ | _ \  /_\ / __|_   _| __| _ \/ __|
# | |\/| | _|  | |/ _ \  | (__| __ |/ _ \|   / / _ \ (__  | | | _||   /\__ \
# |_|  |_|___| |_/_/ \_\  \___|_||_/_/ \_\_|_\/_/ \_\___| |_| |___|_|_\|___/
                                                                          
const meta* = {'(', ')', ',', ':', ';', '[', ']', '{', '}'}

type Meta* = enum
  LParen   = "(", RParen    = ")", Comma    = ",",
  Colon    = ":", Semicolon = ";", LBracket = "[",
  RBracket = "]", LBrace    = "{", RBrace   = "}"

proc toMeta*(c: char): Meta =
  try: return parseEnum[Meta]($c)
  except ValueError: assert false, "something went wrong!"
  # TODO: handle this ^

# __      ___  _ ___ _____ ___ ___ ___  _   ___ ___ 
# \ \    / / || |_ _|_   _| __/ __| _ \/_\ / __| __|
#  \ \/\/ /| __ || |  | | | _|\__ \  _/ _ \ (__| _| 
#   \_/\_/ |_||_|___| |_| |___|___/_|/_/ \_\___|___|
                                                  

const ws* = {'\t', '\n', '\v', '\f', '\r', ' '}


