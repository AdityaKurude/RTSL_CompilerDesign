/* Aditya Anil Kurude 387517, Sai Shyamsundar Kamat 387515, Saptarshi Hazara 387506  */

%option noyywrap

%{
#include "test0.yy.h"
%}  

LETTER		[a-zA-Z]
RTSL_CLASS	"class"
RTSL_MATERIAL	"rt_Material"
IDENTIFIER	("_"[.]+)|({LETTER}+[0-9a-zA-Z"_"]*)

CONDITIONAL_STATMENT	"if"|"else"


NORMAL_INT	{DIGIT}+[uU]?
HEX_VALUE 	0[xX][0-9a-fA-FuU]+


NORMAL_FLOAT_VALUE 		({DIGIT}*\.{DIGIT}+)(f|"lf"|"F"|"LF")?
FLOAT_WITH_TRAILING_DOT		({DIGIT}+\.)(f|"lf"|"F"|"LF")?

TRAILING_EXPO_FLOAT_VALUE	({DIGIT}*\.{DIGIT}*)[eE]{DIGIT}+(f|"lf"|"F"|"LF")?
LEADING_EXPO_FLOAT_VALUE 	{DIGIT}+[eE]("-"|"+")?{DIGIT}+(f|"lf"|"F"|"LF")?

RETURN_KEYWORD	"return"

VOID_KEYWORD	"void"

%%

[ \t\r\v\f]*	{} /*	Remove all Blanks:Includes spaces, tabs, newline and carriage return, vertical tab and form-feed.
			Need to add line number addition logic for error printing */

"\n"	{}

{VOID_KEYWORD}	{return VOID;}

{RETURN_KEYWORD}	{return RETURN;}

{RTSL_MATERIAL}	{return MATERIAL;}

{RTSL_CLASS}	{return CLASS;}

{CONDITIONAL_STATMENT}	{return CONDSTATEMENT;}

{HEX_VALUE} {return(INT);}

{NORMAL_INT} {return(INT);}

{NORMAL_FLOAT_VALUE} {return(FLOAT);}

{FLOAT_WITH_TRAILING_DOT} {return(FLOAT);}

{TRAILING_EXPO_FLOAT_VALUE} {return(FLOAT);}

{LEADING_EXPO_FLOAT_VALUE} {return(FLOAT);}


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


