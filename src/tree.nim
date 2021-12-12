import token, logger, strformat, definitions, strutils

# implement a tree visualization when im done glueing this together
# 1) check https://rosettacode.org/wiki/Visualize_a_tree#Nim

# TODO: store line and column data inside token

type
  ExpressionType = enum
    IntLit, StrLit, Identifier,
    Indexing, FunctionCall, BinaryOp,
    UnaryOp, PostInc, PostDec

  Expression = ref object
    case exprType: ExpressionType:
    of IntLit:
      intValue: int
    of StrLit:
      strValue: string
    of Identifier:
      identValue: string
    of Indexing:
      subject: string
      index: Expression
    of FunctionCall:
      funcName: string
      arguments: seq[Expression]
    of BinaryOp:
      lhs, rhs: Expression
    of UnaryOp:
      on: Expression
    of PostInc, PostDec:
      to: Expression

  StatementType = enum
    IfStmt, WhileStmt, ReturnStmt, VarStmt, Block

  Statement = ref object
    expr: Expression
    case statementType: StatementType:
    of IfStmt, WhileStmt:
      body: Statement
    of VarStmt:
      names: seq[string]
    of Block:
      scope: seq[Variable]
      instructions: seq[Statement]
    else:
      discard
      
  DataType = enum
    IntegerType = "int",
    FloatType   = "float",
    DoubleType  = "double",
    CharType    = "char",
    VoidType    = "void"
    
  Variable = tuple
    name: string
    dataType: DataType
    
  Function = object
    name: string
    ret: DataType
    args: seq[Variable]
    body: Statement
    
  Program = object
    scope: seq[Variable] # unused for now
    functions: seq[Function]


proc toDataType(t: Token): DataType =
  if not (t.kind == Keyword):
    err fmt"expected token {t} to be a keyword"

  case t.keywordValue:
  of Int:
    return IntegerType
  of Float:
    return FloatType
  of Double:
    return DoubleType
  of Char:
    return CharType
  of Void:
    return VoidType
  else:
    err fmt"keyword {t} is not a valid type"


var
  tokens: seq[Token]
  ip = 0
  currentFunction = "" # TODO: track this

template current(): Token = tokens[ip]

template finished(): bool = ip >= tokens.len

proc next(n = 1): Token {.inline, discardable.} =
  ip += n
  if not finished(): tokens[ip]
  else: err "got end of file but expected more tokens"

proc expect(n: int, what: Token | TokenKind) =
  if ip + n >= tokens.len:
    err fmt"expected {what} but got end of file"
  elif tokens[ip + n] != what:
    err fmt"expected {what} but got {tokens[ip + n]}"
  else:
    return

proc expect(n: int, what: DataType) =
  # not sure if i need this
  if ip + n >= tokens.len:
    err fmt"expected {what} but got end of file"
  elif not tokens[ip + n].isType():
    err fmt"expected type but got {tokens[ip + n]}"
  else:
    let t = tokens[ip + n].toDataType
    if t != what:
      err fmt"expected type {what} but got {tokens[ip + n]}"

proc expectAnyType(n: int) =
  if ip + n >= tokens.len:
    err "expected any type but got end of file"
  elif not tokens[ip + n].isType():
    err fmt"expected any type but got {tokens[ip + n]} at ip {ip}"
  else:
    discard

proc parseExpression() = discard

proc parseStatement(): Statement =
  while not (current() == (token RBrace)): # TODO: implement `==` for all the token enums
    inc ip
  inc ip
  return result

proc parseFunction() = discard

proc parseProgram(): Program =
  while not finished():
    expectAnyType(0)
    let dt   = current()
    expect(1, Ident)
    let name = next()  # move to identifier
    next()             # move to '('
    expect(0, token LParen)
    var fn = Function(name: name.identValue, args: @[], ret: dt.toDataType())
    next()
    if current() == (token RParen): # no arguments
      next()
    else:                           # function has arguments
      while not finished():
        expectAnyType(0)
        expect(1, Ident)
        let
          t = current().toDataType()
          n = next().identValue
          
        fn.args.add (n,t) 
        if next() == (token Comma):
          next()
          continue
        elif current() == (token RParen):
          next()
          break
        else:
          err fmt"expected , or ) but got {current()}" 

    fn.body = parseStatement()
    result.functions.add(fn)

proc `$`*(v: Variable): string = fmt"{v.dataType} {v.name}"

proc `$`*(s: seq[Variable]): string = s.join(", ")

proc `$`*(f: Function): string = fmt"{f.name} ({f.args}) -> {f.ret};"

proc `$`*(p: Program): string =
  result = "functions:\n"
  for f in p.functions:
    result &= indent($f, 2) & "\n"


proc toProgram*(tokenList: seq[Token]): Program =
  tokens = tokenList
  return parseProgram()
