%{

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<string>
#include<vector>

int yylex();
void yyerror(const char *s);
extern int yylineno;

void store_var(int digits, char *name);
void remove_terminator(char *str);
int already_stored(char *name);
void valid_var(char *name);
void move_int(int, char *identifier);
void move_identifier(char *identifier1, char *identifier2);
void add_int(int, char *identifier);
void add_identifier(char *identifier1, char *identifier2);
int how_many_digits(int num);
void get_var(char *var);

// Value returned to main function
int exit_val = 1;

int stored_var_count = 0;
std::vector <std::string> var_list;
std::vector <int> var_digits;

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

// This is where the grammar begins
start:		BEGINING TERMINATOR declarations {}

// Allow for multiple declarations
declarations: 	declaration declarations {}
	      	| body {}	

declaration: 	INTDIGITS IDENTIFIER TERMINATOR { store_var($1, $2); }

body: 		BODY TERMINATOR assignments {}

// Allow for multiple assignments
assignments: 	assignment assignments {}
	     	| end {}

assignment:	print | input | move | add {}

print: 		PRINT output {}

output: 	TEXT SEMICOLON output {}
		| IDENTIFIER TERMINATOR { valid_var($1); }
		| IDENTIFIER SEMICOLON output { valid_var($1); }
		| TEXT TERMINATOR {}

input: 		INPUT inputs {}

inputs: 	IDENTIFIER TERMINATOR { valid_var($1); }
		| IDENTIFIER SEMICOLON inputs { valid_var($1); }

move: 		MOVE INTEGER TO IDENTIFIER TERMINATOR { move_int($2, $4); }
      		| MOVE IDENTIFIER TO IDENTIFIER TERMINATOR { move_identifier($2, $4); }

add: 		ADD INTEGER TO IDENTIFIER TERMINATOR { add_int($2, $4); }
     		| ADD IDENTIFIER TO IDENTIFIER TERMINATOR { add_identifier($2, $4); }

end: 		END TERMINATOR { return exit_val; }

%%

void store_var(int digits, char *name){
	
	remove_terminator(name);

	if(!already_stored(name)){
		std::string var_name = name;
		var_list.push_back(var_name);
		var_digits.push_back(digits);
		stored_var_count++;
	}	
	else{
		printf("Warning: Identifier '%s' already exists. [Line: %d]\n", name, yylineno);
		exit_val = 0;
	}
	
}


int already_stored(char *name){

	if (strstr(name, ";") != NULL) {
        	get_var(name);
    	}
	std::string var_name = name;
	int x;
	for(x = 0; x < stored_var_count; x++){
		if(var_name.compare(var_list[x]) == 0){
			return 1;
		}
	}

	return 0;

}


void get_var(char *var){

	for (int i = 0; i < strlen(var); i++) {
		if (var[i] == ';' || var[i] == ' ') {
			var[i] = '\0';
			break;
		}
	}

}


// Removes the '.' from identifiers
void remove_terminator(char *str){

	if (str[strlen(str)-1] == '.') {
        	str[strlen(str)-1] = 0;
    	}

}


// Check if identifier exists & has been set
void valid_var(char *name){

	remove_terminator(name);
	if(already_stored(name)){
		// Do nothing the variable is valid
	}
	else{
		printf("Warning: No identifier found with name '%s'. [Line: %d]\n", name, yylineno);
		exit_val = 0;
	}

}


void move_int(int num, char *identifier){
	
	remove_terminator(identifier);
	
	if(already_stored(identifier)){
		int x;
		std::string var = identifier;
		for(x = 0; x < stored_var_count; x++){
			if(var.compare(var_list[x]) == 0){
				int num_digits = how_many_digits(num);
				if(num_digits > var_digits[x]){
					printf("Warning: Can't move int of size %d to an identifier of size %d. [Line: %d]\n", num_digits, var_digits[x], yylineno);
					exit_val = 0;				
				}
			}
		}
	}
	else{
		printf("Warning: No identifier found with name '%s'. [Line: %d]\n", identifier, yylineno);
		exit_val = 0;
	}

}


void move_identifier(char *identifier1, char *identifier2){

	remove_terminator(identifier1);
	get_var(identifier1);
	remove_terminator(identifier2);

	if(already_stored(identifier1)){
		if(already_stored(identifier2)){
			int size1 = 0;
			int size2 = 0;
			std::string var1 = identifier1;
			std::string var2 = identifier2;
			int x;
			for(x = 0; x < stored_var_count; x++){
				if(var1.compare(var_list[x]) == 0){
					size1 = var_digits[x];
				}
				else if(var2.compare(var_list[x]) == 0){
					size2 = var_digits[x];
				}
			}
			
			if(size1 > size2){
				printf("Warning: Can't move identifier of size %d to an identifier of size %d. [Line: %d]\n", size1, size2, yylineno);
				exit_val = 0;			
			}
			else{
				// Do nothing valid move
			}
		}
		else{
			printf("Warning: No identifier found with name '%s'. [Line: %d]\n", identifier2, yylineno);
			exit_val = 0;
		}
	}
	else{
		printf("Warning: No identifier found with name '%s'. [Line: %d]\n", identifier1, yylineno);
		exit_val = 0;
	}

}


void add_int(int num, char *identifier){
	
	remove_terminator(identifier);
	
	if(already_stored(identifier)){
		int x;
		std::string var = identifier;
		for(x = 0; x < stored_var_count; x++){
			if(var.compare(var_list[x]) == 0){
				int num_digits = how_many_digits(num);
				if(num_digits > var_digits[x]){
					printf("Warning: Can't add int of size %d to an identifier of size %d. [Line: %d]\n", num_digits, var_digits[x], yylineno);
					exit_val = 0;				
				}
			}
		}
	}
	else{
		printf("Warning: No identifier found with name '%s'. [Line: %d]\n", identifier, yylineno);
		exit_val = 0;
	}

}


void add_identifier(char *identifier1, char *identifier2){

	remove_terminator(identifier1);
	get_var(identifier1);
	remove_terminator(identifier2);

	if(already_stored(identifier1)){
		if(already_stored(identifier2)){
			int size1 = 0;
			int size2 = 0;
			std::string var1 = identifier1;
			std::string var2 = identifier2;
			int x;
			for(x = 0; x < stored_var_count; x++){
				if(var1.compare(var_list[x]) == 0){
					size1 = var_digits[x];
				}
				else if(var2.compare(var_list[x]) == 0){
					size2 = var_digits[x];
				}
			}
			
			if(size1 > size2){
				printf("Warning: Can't add identifier of size %d to an identifier of size %d. [Line: %d]\n", size1, size2, yylineno);
				exit_val = 0;			
			}
			else{
				// Do nothing valid add
			}
		}
		else{
			printf("Warning: No identifier found with name '%s'. [Line: %d]\n", identifier2, yylineno);
			exit_val = 0;
		}
	}
	else{
		printf("Warning: No identifier found with name '%s'. [Line: %d]\n", identifier1, yylineno);
		exit_val = 0;
	}

}


int how_many_digits(int num){

	int digits = 0; 
	if(num == 0){
		digits = 1;
	}
	else{
		while (num != 0){ 
			num /= 10; 
			digits++; 
		}
	}

	return digits;

}


void yyerror(const char* s) {

	fprintf(stderr, "Error: %s [Line: %d]\n", s, yylineno);
	exit(1);

}
