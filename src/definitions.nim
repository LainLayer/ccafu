import options, std/setutils, algorithm, strutils

#  _  _______   ____      _____  ___ ___  ___ 
# | |/ / __\ \ / /\ \    / / _ \| _ \   \/ __|
# | ' <| _| \ V /  \ \/\/ / (_) |   / |) \__ \
# |_|\_\___| |_|    \_/\_/ \___/|_|_\___/|___/
                                            
const keywords* = [
  "auto"    , "break"   , "case"    , "char"    ,
  "const"   , "continue", "default" , "do"      ,
  "double"  , "else"    , "enum"    , "extern"  ,
  "float"   , "for"     , "goto"    , "if"      ,
  "inline"  , "int"     , "long"    , "register",
  "restrict", "return"  , "short"   , "signed"  ,
  "sizeof"  , "static"  , "struct"  , "switch"  ,
  "typedef" , "union"   , "unsigned", "void"    ,
  "volatile", "while"]

const keychars* = keywords.join().items.toSet()

type Keywords* = enum
  Auto    , Break   , Case    , Char    ,
  Const   , Continue, Default , Do      ,
  Double  , Else    , Enum    , Extern  ,
  Float   , For     , Goto    , If      ,
  Inline  , Int     , Long    , Register,
  Restrict, Return  , Short   , Signed  ,
  Sizeof  , Static  , Struct  , Switch  ,
  Typedef , Union   , Unsigned, Void    ,
  Volatile, While 

proc tryKeyword*(s: string): Option[Keywords] =
  let index = keywords.binarySearch(s)
  if index >= 0:
    # result = some(cast[Keywords](index))
    result = some(Keywords(index))



#   ___  ___ ___ ___    _ _____ ___  ___  ___ 
#  / _ \| _ \ __| _ \  /_\_   _/ _ \| _ \/ __|
# | (_) |  _/ _||   / / _ \| || (_) |   /\__ \
#  \___/|_| |___|_|_\/_/ \_\_| \___/|_|_\|___/
                                            
const operators* = [
  "!" , "!=", "%" , "%=", "&"  , "&&" ,
  "&=", "*" , "*=", "+" , "++" , "+=" ,
  "-" , "--", "-=", "->", "->*", "."  ,
  "/" , "/=", "<" , "<<", "<<=", "<=" ,
  "=" , "==", ">" , ">=", ">>" , ">>=",
  "^" , "^=", "|" , "|=", "||" , "~"]


type Operators* = enum
  Not     , NotEqual   , Modulus      , ModulusEqual, And           , AndAnd         ,
  AndEqual, Multiply   , MultiplyEqual, Plus        , PlusPlus      , PlusEqual      ,
  Minus   , MinusMinus , MinusEqual   , Arrow       , ArrowStar     , Dot            ,
  Divide  , DivideEqual, Less         , ShiftLeft   , ShiftLeftEqual, SmallerEqual   ,
  Equal   , EqualEqual , Greater      , GreaterEqual, ShiftRight    , ShiftRightEqual,
  Xor     , XorEqual   , Or           , OrEqual     , OrOr          , Destroy


const opchars* = operators.join().items.toSet()

proc tryOperator*(s: string): Option[Operators] =
  let index = operators.binarySearch(s)
  if index >= 0:
    # result = some(cast[Operators](index))
    result = some(Operators(index))

#  __  __ ___ _____ _      ___ _  _   _   ___    _   ___ _____ ___ ___  ___ 
# |  \/  | __|_   _/_\    / __| || | /_\ | _ \  /_\ / __|_   _| __| _ \/ __|
# | |\/| | _|  | |/ _ \  | (__| __ |/ _ \|   / / _ \ (__  | | | _||   /\__ \
# |_|  |_|___| |_/_/ \_\  \___|_||_/_/ \_\_|_\/_/ \_\___| |_| |___|_|_\|___/
                                                                          
const meta* = ['(', ')', ',', ':', ';', '[', ']', '{', '}']

type Meta* = enum 
  LParen, RParen, Comma, Colon, Semicolon, LBracket, RBracket, LBrace, RBrace

# i dont expect this to fail, since the input is
# checked in tokenizer.nim
proc toMeta*(c: char): Meta =
  let index = meta.binarySearch(c)
  if index >= 0:
    # result = cast[Meta](index)
    result = Meta(index)

# __      ___  _ ___ _____ ___ ___ ___  _   ___ ___ 
# \ \    / / || |_ _|_   _| __/ __| _ \/_\ / __| __|
#  \ \/\/ /| __ || |  | | | _|\__ \  _/ _ \ (__| _| 
#   \_/\_/ |_||_|___| |_| |___|___/_|/_/ \_\___|___|
                                                  

const ws* = {'\t', '\n', '\v', '\f', '\r', ' '}


# this is needed for binary search to work
{.push compileTime.}
assert(keywords.isSorted() , "keywords must be sorted")
assert(operators.isSorted(), "operators must be sorted")
assert(meta.isSorted()     , "meta must be sorted")
{.pop.}
