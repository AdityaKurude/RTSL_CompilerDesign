%{
#include <stdio.h>

extern int yylex(); // Declared by lexer
void yyerror(const char *s); // Declared later in file
%}

%glr-parser


%token	IDENTIFIER INT TYPE FLOAT QUANTIFIER
%token IF ELSE RETURN
%token CLASS MATERIAL CAMERA
%token PLUS MUL MINUS DIV ASSIGN COLON SEMICOLON LT GT
%token LPARENTHESIS RPARENTHESIS LBRACKET RBRACKET LBRACE RBRACE
%token WHILE FOR
%token PLUSASSIGN INC

%%

prog:
	%empty
  |prog statement
	|prog declaration
	|prog function_defination
  ;

statement
	:RETURN expression SEMICOLON                        {printf("STATEMENT\n"); }
	|expression ASSIGN expression SEMICOLON							{printf("STATEMENT\n"); }
	|conditional_expression															{printf("STATEMENT\n"); }
	|loop																								{printf("STATEMENT\n"); }
	|postfixexpression SEMICOLON                               {printf("statement\n"); }
	|LBRACE statement RBRACE														{printf("statement\n"); }
	;


loop
  :WHILE expression statement
	|FOR LPARENTHESIS statement SEMICOLON expression SEMICOLON expression RPARENTHESIS statement
	;

declaration
	 :TYPE IDENTIFIER ASSIGN expression SEMICOLON {printf("DECLARATION\n"); }
	 |QUANTIFIER declaration;
	 |TYPE IDENTIFIER SEMICOLON  {printf("DECLARATION \n"); }
	 |CLASS IDENTIFIER COLON type SEMICOLON
	 ;


conditional_expression
	  :IF expression statement ELSE statement   {printf("IF ELSE STATEMENT\n"); }
	  ;

	expression
	  :LPARENTHESIS expression RPARENTHESIS
		|expression OP expression
		|term
		|IDENTIFIER
		|function_call
		;

postfixexpression
    :expression
    |expression INC
    ;

assignment_operator
    :PLUSASSIGN
		;
function_call
  :IDENTIFIER LPARENTHESIS parameter_list_list RPARENTHESIS
	;

function_defination
  :TYPE function_call LBRACE  block_list  RBRACE   {printf("FUNCTION DEF\n"); }
  ;


parameter_list_list:
     %empty
		 |parameter_list

	parameter_list
			:parameter
		  |parameter_list parameter
		  ;

			parameter
			:TYPE IDENTIFIER
			 |IDENTIFIER
			 ;


block_list
  :block
  |block_list block
  ;

block
  :statement
  |declaration
  ;

term
 :INT
 |FLOAT
 ;

OP
 :PLUS
 |MINUS
 |DIV
 |MUL
 |LT
 |GT
 |assignment_operator
 ;

type
 :MATERIAL {printf("SHADER DEF material \n");}
 |CAMERA  {printf("SHADER DEF camera \n");}
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
