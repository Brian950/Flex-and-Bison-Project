%{

#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int yylex();
void yyerror(const char *s);
extern FILE *yyin;

extern int yylineno;

%}

%union {
	char *name; 
	int digits;
	int num;
	char *text;
	char *unknown;
}
%start start
%token <name> IDENTIFIER
%token <digits> INTEGER
%token <digits> INTDIGITS
%token BEGINING BODY MOVE TO ADD INPUT PRINT END TEXT SEMICOLON TERMINATOR UNKNOWN

%%

start:	BEGINING TERMINATOR declarations {}

declarations: {}

%%

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s [Line: %d]\n", s, yylineno);
	exit(1);
}
