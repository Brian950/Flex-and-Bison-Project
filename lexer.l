%{
	#include "parser.tab.h"
%}
%option yylineno
%option noyywrap
%%
[\t\n ]+
(?i:BEGINING)		{ return BEGINING; }
(?i:BODY)		{ return BODY; }
(?i:MOVE)		{ return MOVE; }
(?i:TO)			{ return TO; }
(?i:ADD)		{ return ADD; }
(?i:INPUT)		{ return INPUT; }
(?i:PRINT)		{ return PRINT; }
(?i:END)		{ return END; }
[0-9]+			{ yylval.num = atoi(yytext); return INTEGER; }
[xX]+			{ yylval.digits = strlen(yytext); return INTDIGITS; }
[a-zA-Z][a-zA-Z0-9\-]*	{ yylval.name = yytext; return IDENTIFIER; }
\"([^"])*\"		{ yylval.text = yytext; return TEXT; }
;			{ return SEMICOLON; }
\.			{ return TERMINATOR; }
.			{ yylval.unknown = yytext; return UNKNOWN; }
%%
