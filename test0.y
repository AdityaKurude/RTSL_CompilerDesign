/* Example 2, Simple Calculator Parser */
%{
#include <stdio.h>

extern int yylex(); // Declared by lexer
void yyerror(const char *s); // Declared later in file
%}

/* declare tokens */
//%glr-parser
//%expect-sr
%token CLASS
%token MATERIAL
%token IDENTIFIER
%token COLON VOID
%token SEMICOLON CONDSTATEMENT FLOAT INT LBRACKET RBRACKET LBRACE RBRACE

%%


declar: term expr COLON MATERIAL SEMICOLON { printf("SHADER_DEF"); }
	;

functiondecl:datatype IDENTIFIER
	| FLOAT
	| VOID
	;

datatype: INT
	| FLOAT
	| VOID
	;

expr:	IDENTIFIER	{ printf("ID"); }
	;

term:	CLASS	{ printf("material"); }
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
