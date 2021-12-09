import tokenizer, logger, strutils, tree
info "compiler started."

# TODO: make this read from command line arguments
info "reading file test.c"
let text = readFile("test.c")

let tokens = tokenize(text)

debug "tokenizing finished."

debug " -==-==-== >-< ==-==-==-"
let program = toTree(tokens)
echo program
