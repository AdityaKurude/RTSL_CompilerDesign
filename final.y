%{
#include <stdio.h>
#include <string.h>

extern int yylex(); // Declared by lexer
void yyerror(const char *s); // Declared later in file
//int function_type(char*);
void error_write(int,int);
/*
type =0 :CAMERA
     =1 :PRIMITIVE
     =2 :TEXTURE
     =3 :MATERIAL
     =4 :LIGHT
*/
int type=-1;
int error_type=-1;
%}

%glr-parser


%token	IDENTIFIER INT TYPE FLOAT QUANTIFIER BOOL CHAR LONG DOUBLE SIGNED UNSIGNED VOID SHORT
%token IF ELSE RETURN
%token CLASS MATERIAL CAMERA TEXTURE LIGHT PRIMITIVE
%token MUL_ASSIGN DIV_ASSIGN ADD_ASSIGN	SUB_ASSIGN PLUS_ASSIGN	COLON SEMICOLON LT GT
%token WHILE FOR
%token INC_OP DEC_OP EQ_OP GE_OP LE_OP NE_OP
%token INTER_MATERIAL INTER_TEXTURE INTER_LIGHT INTER_CAMERA INTER_PRIMITIVE

%%
prog
  :
  |prog statement
  |prog external_declaration
  ;


statement
	: compound_statement {printf("STATEMENT \n");}
	| expression_statement {printf("STATEMENT \n");}
	| selection_statement {printf("STATEMENT \n");}
	| iteration_statement {printf("STATEMENT \n");}
  | jump_statement {printf("STATEMENT \n");}
  ;

primary_expression
	: IDENTIFIER
  | term
  | TYPE
  |'-' primary_expression
	| '(' assignment_expression ')'
	;

term
 :INT
 |FLOAT
 ;

compound_statement
	: '{' '}'
	| '{'  block_item_list '}'
	;

block_item_list
	: block_item
	| block_item_list block_item
	;

block_item
	: declaration {printf("DECLARATION \n");}
	| statement
	;

type_specifier
  : TYPE
  | QUANTIFIER TYPE
//	: VOID
//	| INT
//	| FLOAT
  ;

expression_statement
	: ';'
	| assignment_expression ';'
	;

assignment_expression
  :unary_expression assignment_operator assignment_expression
  |equality_expression
	;


unary_expression
	: postfix_expression
	| INC_OP unary_expression
	| DEC_OP unary_expression
	;

postfix_expression
  : primary_expression
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
  | postfix_expression '(' argument_expression_list ')'
  ;

argument_expression_list
	: assignment_expression
	| argument_expression_list ',' assignment_expression
	;

assignment_operator
	: '='
	| MUL_ASSIGN
	| DIV_ASSIGN
	| PLUS_ASSIGN
	| SUB_ASSIGN
  ;

equality_expression
	: relational_expression
	| equality_expression EQ_OP relational_expression
	| equality_expression NE_OP relational_expression
	;

relational_expression
  : additive_expression
	| relational_expression LE_OP additive_expression
	| relational_expression GE_OP additive_expression
  | relational_expression '<' additive_expression
  | relational_expression '>' additive_expression
	;

additive_expression
	: multiplicative_expression
	| additive_expression '+' multiplicative_expression
	| additive_expression '-' multiplicative_expression
	;

multiplicative_expression
	: unary_expression
	| multiplicative_expression '*' unary_expression
	| multiplicative_expression '/' unary_expression
	;

selection_statement
	: IF '(' assignment_expression ')' statement ELSE statement {printf("IF_ELSE statement \n");}
	| IF '(' assignment_expression ')' statement {printf("IF \n"); }
	;

iteration_statement
	: WHILE '(' assignment_expression ')' statement
	| FOR '(' expression_statement expression_statement ')' statement
	| FOR '(' expression_statement expression_statement assignment_expression ')' statement
	| FOR '(' declaration expression_statement ')' statement
	| FOR '(' declaration expression_statement assignment_expression ')' statement
	;

jump_statement
	: RETURN ';'
	| RETURN assignment_expression ';'
	;

external_declaration
	: functionclass_definition
	| declaration {printf("DECLARATION \n");}
	;

functionclass_definition
	: type_specifier direct_declarator compound_statement {printf("FUNCTION_DEF \n"); error_write(type,error_type); }
  | CLASS IDENTIFIER ':' type ';'
	;

type
 :MATERIAL {type=3; printf("SHADER_DEF material \n");}
 |CAMERA {type=0; printf("SHADER_DEF camera \n"); }
 |PRIMITIVE {type=1; printf("SHADER_DEF primitive \n"); }
 |TEXTURE {type=2; printf("SHADER_DEF texture \n"); }
 |LIGHT {type=4; printf("SHADER_DEF light  \n"); }
;

direct_declarator
	: IDENTIFIER
  | INTER_CAMERA {error_type=0;}
  | INTER_PRIMITIVE {error_type=1;}
  | INTER_TEXTURE {error_type=2;}
  | INTER_MATERIAL {error_type=3;}
  | INTER_LIGHT {error_type=4;}
	| direct_declarator '(' parameter_list ')'
	| direct_declarator '(' ')'
	;


parameter_list
  : parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration
	: type_specifier direct_declarator
	| type_specifier
	;

/*identifier_list
  	: IDENTIFIER
  	| identifier_list ',' IDENTIFIER
  	;
*/

init_declarator
	: direct_declarator '=' assignment_expression
	| direct_declarator
	;

init_declarator_list
	: init_declarator
	| init_declarator_list ',' init_declarator
	;


declaration
	: type_specifier ';'
	| type_specifier init_declarator_list ';'
  ;

	%%

	int main(int argc, char const *argv[]) {
	 extern FILE* yyin;
	 yyin = fopen(argv[1],"r");
	 yyparse();
	}

	void yyerror(char const *s)
	{
	  fprintf(stderr, "error: %s\n", s);
	}

void error_write(int a,int b)
{
  char c[10];
  char d[10];
  if((a!=b)&& b>=0)
   {
     switch(a)
     {
       case 0:
        strcpy(c,"camera");
        break;
       case 3:
        strcpy(c,"material");
        break;
     }
     switch(b)
     {
       case 0:
        strcpy(d,"camera");
        break;
       case 3:
        strcpy(d,"material");
        break;
     }

     fprintf(stderr, "Error: %s cannot have an interface method of ",c);
     fprintf(stderr,"%s \n",d);
   }
   error_type=-1;
}
