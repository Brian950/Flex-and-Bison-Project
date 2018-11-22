enum jibuctokentype{
        BEGINING = 258,
        BODY = 259,
        MOVE = 260,
        TO = 261,
        ADD = 262,
        INPUT = 263,
        PRINT = 264,
        END = 265,
        INTEGER = 266,  
        INTDIGITS = 267,
        IDENTIFIER = 268,
        SEMICOLON = 269,
	TEXT = 270,
	EOL = 271,
	UNKNOWN = 300
};

struct Values{
	int num;
        int digits;
        char *name;
	char *text;
	char *unknown;
} yylval;
