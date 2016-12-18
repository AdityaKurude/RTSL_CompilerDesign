/* Aditya Anil Kurude 387517, Sai Shyamsundar Kamat 387515, Saptarshi Hazara 387506  */

%option noyywrap

%{
#include "final.yy.h"
int line_no=0;
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
RTSL_CAMERA "rt_Camera"

C_KEYWORDS	"break"|"case"|"const"|"continue"|"default"|"do"|"double"|"enum"|"extern"|"for"|"goto"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"
BUILT_IN_FUNCTION	"dominantAxis"|"dot"|"hit"|"inside"|"inverse"|"luminance"|"max"|"min"|"normalize"|"perpendicularTo"|"pow"|"rand"|"reflect"|"sqrt"|"trace"

RTSL_TYPE	"int"|"float"|"bool"|"void"|"color"

VECTOR_TYPE	[i|b]?vec[2-4]

STATE	[r][t][_]({LETTER}+[0-9"_"]*)+


IDENTIFIER	("_"[.]+)|({LETTER}+[0-9a-zA-Z"_"]*)
ERROR_IDENTIFIER	[0-9]+{LETTER}*[0-9"_"]*``

SWIZZLE	[.]{IDENTIFIER}

%%

[ \t\n\r\v\f]*	{} /*	Remove all Blanks:Includes spaces, tabs, newline and carriage return, vertical tab and form-feed.
			Need to add line number addition logic for error printing */


{SINGLELINE_COMMENT}	{}


"return" {return RETURN; }
{RTSL_MATERIAL}	{return MATERIAL ;}
{RTSL_CAMERA} {return CAMERA; }
{CLASS_SCOPE_QUALIFIERS} {return QUANTIFIER; }
"while" {return WHILE; }
"for" {return FOR; }
"++" {return INC_OP;}

{RTSL_CLASS}	{return CLASS;}

{NORMAL_INT} {return INT;}
{NORMAL_FLOAT_VALUE}|{FLOAT_WITH_TRAILING_DOT} {return FLOAT;}

{RTSL_TYPE}|{VECTOR_TYPE}	{ return TYPE; }

"if" {return IF; }
"else" {return ELSE; }
">=" {return GE_OP;}
[,] {return ',';}
[+]	{return '+';}
[*]	{return '*';}
[-]	{return '-';}
[/]	{return '/';}
[=]	{return '=';}
[:]	{return ':';}
[;]	{return ';';}
[<] {return '<'; }
[>] {return '>'; }
"+=" {return PLUS_ASSIGN; }
[(]	{return '(' ;}
[)]	{return ')' ;}
"["	{return '['; }
"]"	{return ']'; }
[{]	{return '{'; }
[}]	{return '}'; }
{IDENTIFIER} { yylval=yytext; return IDENTIFIER; }




%%
