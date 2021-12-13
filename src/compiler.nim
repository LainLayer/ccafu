import tokenizer, logger, strutils, tree
info "compiler started."

# TODO: make this read from command line arguments
info "reading file test.c"
const text = readFile("test.c")

let tokens = tokenize(text)

debug "tokenizing finished."

debug " -==-==-== >-< ==-==-==-"

let program = toProgram(tokens)
echo program

