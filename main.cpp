#include <iostream>

extern int yyparse();

int main(){
	int result = yyparse();
	if(result)
		std::cout << "Valid JIBUC program." << std::endl;
	else
		std::cout << "Inavlid JIBUC program." << std::endl;

	return result;
}
