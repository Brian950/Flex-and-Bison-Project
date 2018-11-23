all:
	${MAKE} parser
	${MAKE} lexer
	g++ parser.tab.c lex.yy.c main.cpp

parser:
	bison -d parser.y

lexer:
	flex lexer.l
