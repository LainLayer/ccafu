import token, strformat, definitions, logger


type Scope = object
  identifiers: seq[string] # TODO: make it save the type
  body: seq[Token]

var
  ip = 0
  tokens: seq[Token]
  tree: seq[Token]
  scopeStack: seq[Scope]

template current(): Token = tokens[ip]

template finished(): bool = ip >= tokens.len

template currentScope(): Scope = scopeStack[scopeStack.len - 1]

proc next(n=1): Token =
  ip += n
  if not finished():
    return tokens[ip]

proc peek(n: int): Token =
  if ip + n < tokens.len:
    return tokens[ip + n]
  else:
    err "unexpected end of file"

proc expect(where: int, what: Token | TokenKind) =
  if ip + where >= tokens.len:
    err "expected " & $what & " but got end of file"
  if not (tokens[ip + where] == what):
    err "expected " & $what & " but got " & $tokens[ip + where]

proc inScope(s: string): bool =
  for ta in scopeStack:
    if ta.identifiers.contains(s):
      return true
  return false

template popScopeStack() = discard scopeStack.pop()

proc defineIdent(t: Token) =
  if not (t.kind == Ident): err "got " & $t & "in defineIdent"
  if not inScope(t.identValue):
    currentScope().identifiers.add(t.identValue)
  else:
    err "redefinition of " & t.identValue


proc parseExpression() = # TODO
  debug "parse expression"

proc parseBlock() = # TODO
  debug "parse block"

proc parseFunctionDeclaration() =
  debug "parse function declaration"
  let name = next()
  if scopeStack.len != 1:
    err "function declaration not allowed outside of global scope"
  discard next(2) # skip '('

  # open new scope
  scopeStack.add Scope(
      identifiers: @[],
      body: @[])
  
  while current() != token RParen:
    expect(0, token Int) # TODO: add more types
    expect(1, Ident)
    defineIdent(peek(1))
    
    let p = next(2)
    if p == token Comma:
      continue
    elif p == token RParen:
      break

  let p = next(1)
  if p == token SemiColon:
    popScopeStack()
    discard next()
    return # function declaration without implementation
  elif p == token LBrace:
    discard next()
    parseBlock()
    
    
    
  

proc parseVariableDeclaration() =
  debug "parse variable declaration"
  let name = next()
  defineIdent(name)
  var node = token Equal
  node.children.add(name)
  tree.add(node)
  discard next(2) # skip '='
  parseExpression()
  
  

proc parseDeclaration() =
  expect(1, Ident)
  let p = peek(2)
  if p == (token Equal):
    parseVariableDeclaration()
  elif p == (token LParen):
    parseFunctionDeclaration()
  else:
    err "unexpected token " & $p & ". expected ( or =."

proc parse() =
  while not finished():
    case current().kind:
    of Keyword:
      case current().keywordValue:
      of Int, Void:
        parseDeclaration()
      else:
        err "not implemented " & $current()
    else:
      echo tree
      err "not implemented " & $current()

proc toTree*(t: seq[Token]): seq[Token] =
  # TODO: add function token type and push it to the tree
  tokens = t
  scopeStack.add Scope(
    identifiers: @[],
    body: @[]) # global scope

  # start parsing
  parse()
  echo tree
