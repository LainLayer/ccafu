import tokenizer, logger, tree

# TODO: make this read from command line arguments

info "compiler started."
info "reading file test.c"

let text = readFile("test.c")

# used for error messages
loggerText = text

let tokens = tokenize(text)



debug "tokenizing finished."

debug " -==-==-== >-< ==-==-==-"

let program = toProgram(tokens, text)
echo program

