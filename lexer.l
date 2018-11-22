%{
	int intDigits(char*);
	#include "yylheader.h"
%}

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
[xX]+			{ yylval.digits = intDigits(yytext); return INTDIGITS; }
[a-zA-Z][a-zA-Z0-9\-]*	{ yylval.name = yytext; return IDENTIFIER; }
\"([^"])*\"		{ yylval.text = yytext; return TEXT; }
;			{ return SEMICOLON; }
\.			{ return EOL; }
.			{ yylval.unknown = yytext; return UNKNOWN; }
%%

main(int argc, char **argv)
{
	int tok;

	while(tok = yylex()){
		
		switch(tok){
			
			case BEGINING:
				printf("BEGINING found.\n");
				break;
			case BODY:
				printf("BODY found.\n");
				break;
			case MOVE:
				printf("MOVE found.\n");
				break;
			case TO:
				printf("TO found.\n");
				break;
			case ADD:
				printf("ADD found.\n");
				break;
			case INPUT:
				printf("INPUT found.\n");
				break;
			case PRINT:
				printf("PRINT found.\n");
				break;
			case END:
				printf("END found.\n");
				break;
			case INTEGER:
				printf("INTEGER found. (Value: %d)\n", yylval.num);
				break;
			case INTDIGITS:
				printf("INTDIGITS found. (Value: %d)\n", yylval.digits);
				break;
			case IDENTIFIER:
				printf("INDENTIFIER found. (Name: %s)\n", yylval.name);
				break;
			case SEMICOLON:
				printf("SEMICOLON found.\n");
				break;
			case TEXT:
				printf("TEXT found. (Value: %s)\n", yylval.text);
				break;
			case EOL:
				printf("EOL found.\n");
				break;
			case UNKNOWN:
				printf("UNKNOWN found. (Value: %s)\n", yylval.unknown);
				break;
		}
	}
}

int intDigits(char *size){
	int x = 0;
	while (*size++) x++;
	return x;
}
