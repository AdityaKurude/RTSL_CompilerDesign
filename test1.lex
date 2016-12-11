/* Aditya Anil Kurude 387517, Sai Shyamsundar Kamat 387515, Saptarshi Hazara 387506  */

%option noyywrap

%{
#include "test0.yy.h"
%}  
LETTER	[a-zA-Z]
DIGIT	[0-9]

MULTILINE_COMMENTS	[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]
SINGLELINE_COMMENT	(("/""/")(.)*)

VARIABLE_QUALIFIERS 	"attribute"|"uniform"|"varying"|"const"
CLASS_SCOPE_QUALIFIERS	"const"|"public"|"private"|"scratch"


NORMAL_INT	{DIGIT}+[uU]?
HEX_VALUE 	0[xX][0-9a-fA-FuU]+


NORMAL_FLOAT_VALUE 		({DIGIT}*\.{DIGIT}+)(f|"lf"|"F"|"LF")?
FLOAT_WITH_TRAILING_DOT		({DIGIT}+\.)(f|"lf"|"F"|"LF")?

TRAILING_EXPO_FLOAT_VALUE	({DIGIT}*\.{DIGIT}*)[eE]{DIGIT}+(f|"lf"|"F"|"LF")?
LEADING_EXPO_FLOAT_VALUE 	{DIGIT}+[eE]("-"|"+")?{DIGIT}+(f|"lf"|"F"|"LF")?

RTSL_CLASS	"class"
RTSL_MATERIAL	"rt_Material"

C_KEYWORDS	"break"|"case"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"for"|"goto"|"if"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"while"
RTSL_KEYWORDS	"illuminance"|"ambient"
BUILT_IN_FUNCTION	"dominantAxis"|"dot"|"hit"|"inside"|"inverse"|"luminance"|"max"|"min"|"normalize"|"perpendicularTo"|"pow"|"rand"|"reflect"|"sqrt"|"trace"

RTSL_TYPE	"int"|"float"|"bool"|"void"|"rt_Primitive"|"rt_Camera"|"rt_Texture"|"rt_Light"

VECTOR_TYPE	[i|b]?vec[2-4]

STATE	[r][t][_]({LETTER}+[0-9"_"]*)+


IDENTIFIER	("_"[.]+)|({LETTER}+[0-9a-zA-Z"_"]*)
ERROR_IDENTIFIER	[0-9]+{LETTER}*[0-9"_"]*

SWIZZLE	[.]{IDENTIFIER}	

%%

[ \t\r\v\f]*	{} /*	Remove all Blanks:Includes spaces, tabs, newline and carriage return, vertical tab and form-feed.
			Need to add line number addition logic for error printing */

"\n"	{line_no++;}


{SINGLELINE_COMMENT}	{}

{MULTILINE_COMMENTS}	{
				int count =0;				
				char* str = yytext;

				for(count =0;count < yyleng; count++)
				{
					if('\n' == *str)
					line_no++;
					
					str++;
				}
			}
RTSL_MATERIAL	{return(MATERIAL);}

RTSL_CLASS	{return(CLASS);}

true|false	{return(BOOL);}

{HEX_VALUE} {return(INT);}

{NORMAL_INT} {return(INT);}

{NORMAL_FLOAT_VALUE} {return(FLOAT);}

{FLOAT_WITH_TRAILING_DOT} {return(FLOAT);}

{TRAILING_EXPO_FLOAT_VALUE} {return(FLOAT);}

{LEADING_EXPO_FLOAT_VALUE} {return(FLOAT);}

{VARIABLE_QUALIFIERS}|{CLASS_SCOPE_QUALIFIERS}	{return(QUALIFIER);}


{RTSL_TYPE}|{VECTOR_TYPE}	{ return(TYPE); }



{STATE}	{ return(STATE); }

{C_KEYWORDS}|{RTSL_KEYWORDS}|{BUILT_IN_FUNCTION}	{ return(KEYWORD); }

{SWIZZLE}	{return(SWIZZLE);}

[+]	{return(PLUS);}
[*]	{return(MUL);}
[-]	{return(MINUS);}
[/]	{return(DIV);}
[=]	{return(ASSIGN);}
[=][=]	{return(EQUAL);}
[!][=]	{return(NOT_EQUAL);}
[<]	{return(LT);}
[<][=]	{return(LE);}
[>]	{return(GT);}
[>][=]	{return(GE);}
[,]	{return(COMMA);}
[:]	{return(COLON);}
[;]	{return(SEMICOLON);}
[(]	{return(LPARENTHESIS);}
[)]	{return(RPARENTHESIS);}
"["	{return(LBRACKET);}
"]"	{return(RBRACKET);}
[{]	{return(LBRACE);}
[}]	{return(RBRACE);}
[&][&]	{return(AND);}
"|""|"	{return(OR);}
"+""+"	{return(INC);}
"-""-"	{return(DEC);}


{IDENTIFIER} {return(IDENTIFIER);}

%%
