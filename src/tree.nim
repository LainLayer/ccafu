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
    IfStmt, WhileStmt, ReturnStmt, VarStmt, Block, ExprStmt

  Statement = ref object
    case statementType: StatementType:
    of IfStmt, WhileStmt:
      condExpr: Expression
      body: Statement
    of VarStmt:
      assignExpr: Expression
      name: string
    of Block:
      scope: seq[Variable] # TODO: push this to a stack
      instructions: seq[Statement]
    of ReturnStmt:
      value: Expression
    else:
      self: Expression
      
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

template finished(): bool = ip >= (tokens.len-1)

template peek(n: int): Token =
  if ip+n < tokens.len:
    tokens[ip+n]
  else:
    err fmt"got end of file but expected more tokens on current"

proc next(n = 1): Token {.inline, discardable.} =
  let c = current()
  ip += n
  if ip < tokens.len:
    debug fmt"{n} + {ip:>3} + {c:<17} -> {tokens[ip]:>17}"
    return tokens[ip]
  else:
    debug "failed"
    err fmt"got end of file but expected more tokens on current = {peek(-n)} {n}"

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

proc parseExpression(): Expression =
  debug fmt"skipping expression"
  while not( current() == (token RBrace) or current() == (token SemiColon)):
    next()
    # inc ip
  return Expression(exprType: IntLit, intValue: 1)

proc parseStatement(): Statement =
  if current() == (token LBrace): # block statement
    debug "block"
    let ret = Statement(statementType: Block)
    next()
    while current() != (token RBrace):
      ret.instructions.add(parseStatement())
    if not finished(): next()
    return ret

  elif current() == (token If):
    debug "if"
    expect(1, token LParen)
    next(2)
    if current() == (token RParen):
      err "expression expected in if statement"
    let s = Statement(
      statementType: IfStmt,
      condExpr: parseExpression(),
      body: parseStatement())
    if not finished(): next()
    debug "end if"
    return s
    
  elif current() == (token While):
    debug "while"
    expect(1, token LParen)
    next(2)
    if peek(1) == (token RParen):
      err "expression expected in if statement"
    let s = Statement(
      statementType: WhileStmt,
      condExpr: parseExpression(),
      body: parseStatement())
    if not finished(): next()
    debug "end while"
    return s

  elif current() == (token Return):
    debug "return"
    next()
    let s = Statement(
        statementType: ReturnStmt,
        value: parseExpression())
    expect(0, token SemiColon)
    if not finished(): next()
    debug "end return"
    return s

  elif current().isType():
    debug "variable"
    expect(1, Ident)
    let n = next().identValue
    expect(1, token Equal)
    next(2)

    let s = Statement(
        statementType: VarStmt,
        assignExpr: parseExpression(),
        name: n)
    expect(0, token SemiColon)
    if not finished(): next()
    debug "end variable"
    return s
    
  else:
    debug "standalone expression"
    let s = Statement(
        statementType: ExprStmt,
        self: parseExpression())
    # next()
    expect(0, token SemiColon)
    debug "end standalone expression"
    return s

  
proc parseFunction() = discard # TODO: oops. move code below into here

proc parseProgram(): Program =
  while not finished():
    debug "function"
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
    debug "end function"



proc `$`*(e: Expression):    string = "expression"

proc `$`*(s: Statement):     string =
  case s.statementType:
  of IfStmt:
    return fmt"if ({s.condExpr}):"
  of WhileStmt:
    return fmt"while ({s.condExpr}):"
  of ReturnStmt:
    return fmt"return {s.value}"
  of VarStmt:
    return fmt"var {s.name} := {s.assignExpr}"
  of Block:
    return "block:"
  of ExprStmt:
    return $s.self
  
proc `$`*(v: Variable):      string = fmt"{v.dataType} {v.name}"

proc `$`*(s: seq[Variable]): string = "(" & s.join(", ") & ")"

proc `$`*(f: Function):      string =
  result = &"{f.name:<5} {f.args:<15} -> {f.ret}:\n"
  result &= indent($f.body, 2) & "\n"
  case f.body.statementType:
  of Block:
    result &= f.body.instructions.join("\n").indent(4)
  else:
    discard
  

proc `$`*(p: Program): string =
  "functions:\n" & p.functions.join("\n\n").indent(2)


proc toProgram*(tokenList: seq[Token]): Program =
  tokens = tokenList
  return parseProgram()
