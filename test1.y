%{
#include <stdio.h>

extern int yylex(); // Declared by lexer
void yyerror(const char *s); // Declared later in file
%}

%glr-parser
%token	IDENTIFIER INT TYPE
%token IF ELSE RETURN
%token CLASS MATERIAL
%token PLUS MUL MINUS DIV ASSIGN COLON SEMICOLON LT LPARENTHESIS RPARENTHESIS LBRACKET RBRACKET LBRACE RBRACE


%%

statement
 :function_call
 |declaration
 ;

function_call
  :IDENTIFIER LPARENTHESIS parameter RPARENTHESIS SEMICOLON {printf("FUNCTION CALL"); }
 	;

declaration
  :class parameter COLON MATERIAL SEMICOLON      {printf("SHADER DEF material"); }
   ;

 parameter_list
   :parameter
   |parameter_list parameter
   ;

 parameter
   :IDENTIFIER
   ;
class
   :CLASS
   ;


%%

int main(int argc, char const *argv[]) {
 extern FILE* yyin;
 yyin = fopen(argv[1],"r");
 yyparse();
}

void yyerror(const char *s)
{
  fprintf(stderr, "error: %s\n", s);
}
