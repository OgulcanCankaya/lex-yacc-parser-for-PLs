%option yylineno
%{
	#include<stdio.h>
	#include"y.tab.h"
	#include<math.h>
%}
%%
"int"|"flt"|"dbl"|"bool"|"str"|"tdo"|"graph" {return DATA_TYPE;}
"road" {return ROAD;}
"user" {return USER;}
"arr" {return ARRAY;}
"d0ru"|"yannis" {return TR_FA;}
"fdef" {return FUNCTION_DEF;}
"#" {return ARRAY_INITIALISER;}
"if" {return IF;}
"else" {return ELSE;}
"for" {return FOR;}
"while" {return WHILE;}
"continue" {return CONTINUE;}
"break" {return BREAK;}
"return" {return RETURN;}
"sizeof" {return SIZEOF;}
"||" {return OR;}
"&&" {return AND;}
"=="|"!=" {return IS_EQUAL_OR_NOT;}
"<="|">=" {return S_OR_B_EQ;}
"++"|"--" {return INCREMENT;}
"*="|"/="|"+="|"-=" {return PUNC;}
"display" {return DISPLAY;}
"showonmap" {return SHOW_ON_MAP;}
"searchlocation" {return SEARCH_LOCATION;}
"getroadspeed" {return GET_ROAD_SPEED;}
"getlocation" {return GET_LOCATION;}
"showtarget" {return SHOW_TARGET;}
[0]|[+-]?[1-9]([0-9]*)? {return INT_DEF;}
[0-9]+"."[0-9]+ {return FLOAT_DEF;}
[a-zA-z_][a-zA-z_0-9]* {return VARIABLE_NAME;}
\"(\\.|[^\"])*\" {return STRING;}
"'"."'"  {return CHAR;}
";"|"="|","|"{"|"}"|"("|")"|"["|"]"|"*"|"+"|"-"|"/"|"?"|":"|"&"|"|"|"^"|"!"|"~"|"%"|"<"|">"  {return yytext[0];}
"//"(\\.|[^\n])*[\n] ;
[/][*]([^*]|[*]*[^*/])*[*]+[/] ;
[ \t\n] ;

"->" {return POINT_CONST;}

%%
int yywrap(void)
{
    return 1;
}