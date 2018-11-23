#include <iostream>

extern int yyparse();

int main(){
	int result = yyparse();
	if(result)
		std::cout << "Valid JIBUC program." << std::endl;
	else
		std::cout << "Invalid JIBUC program." << std::endl;

	return result;
}
