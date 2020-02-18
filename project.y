%{
	#include<stdio.h>
	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
%}

%token IF ELSE FOR DO WHILE BREAK CONTINUE RETURN SIZEOF DATA_TYPE CHAR STRING ARRAY FUNCTION_DEF SHOW_ON_MAP
%token AND OR INT_DEF PUNC TR_FA FLOAT_DEF VARIABLE_NAME S_OR_B_EQ IS_EQUAL_OR_NOT ARRAY_INITIALISER POINT_CONST INCREMENT DISPLAY
%token SEARCH_LOCATION GET_ROAD_SPEED GET_LOCATION SHOW_TARGET USER ROAD
%left '+' '-'
%left '*' '/'
%nonassoc ELSE
%start program_unit
%%


program_unit	: external_decl 	
	| program_unit external_decl	
	;
external_decl	: function_definition
	| decl
	;
function_definition	: FUNCTION_DEF decl_specs direct_declarator compound_stat 	
	;
decl	: decl_specs init_declarator_list ';' 	
	| decl_specs ';'
	;
decl_list	: decl
	| decl_list decl
	;
decl_specs	: DATA_TYPE 	
	| ARRAY DATA_TYPE 
	| ARRAY USER
	| ARRAY ROAD
	;
init_declarator_list	: init_declarator
	| init_declarator_list ',' init_declarator
	;
init_declarator	: direct_declarator
	| direct_declarator '=' initializer
	;
spec_qualifier_list	: DATA_TYPE spec_qualifier_list
	| DATA_TYPE
	;
direct_declarator	: VARIABLE_NAME
	| '(' direct_declarator ')'	 
	| direct_declarator ARRAY_INITIALISER INT_DEF
	| direct_declarator '(' variable_list ')' 	
	| direct_declarator '(' param_list ')' 
	| direct_declarator '('	')' 
	;
param_list	: 	param_type
	|	param_list ',' param_type
	;
param_type	: DATA_TYPE VARIABLE_NAME
	;
variable_list	: VARIABLE_NAME
	| variable_list ',' VARIABLE_NAME
	;
initializer	: assignment_exp
	| '{' initializer_list '}'
	| '{' initializer_list ',' '}'
	;
initializer_list	: initializer
	| initializer_list ',' initializer
	;

type_name	: spec_qualifier_list abstract_declarator
	| spec_qualifier_list
	;
abstract_declarator	: direct_abstract_declarator
	;
    
direct_abstract_declarator	: '(' abstract_declarator ')'
	| direct_abstract_declarator '(' ')'
	| '(' ')'
	;

stat	: exp_stat 	  	
	| compound_stat 	  	
	| selection_stat  	  
	| iteration_stat
	| jump_stat
	| builtin_stat
	;
builtin_stat	: DISPLAY '(' exp ')' 
	| SHOW_ON_MAP '(' exp ',' exp ')'
	| SEARCH_LOCATION '(' exp ')'
	| GET_ROAD_SPEED '(' exp ')'
	| GET_LOCATION '(' exp ')'
	| SHOW_TARGET '(' exp ')' 
	;
exp_stat	: exp ';'
	| ';'
	;
compound_stat	: '{' decl_list stat_list '}'   	
	| '{' stat_list '}'	
	| '{' decl_list	'}'	
	| '{' '}'	
	;
stat_list	: stat     	
	| stat_list stat  	
	;
selection_stat	: IF '(' exp ')' stat
	| IF '(' exp ')' stat ELSE stat
	;
iteration_stat	: WHILE '(' exp ')' stat
	| FOR '(' exp ';' exp ';' exp ')' stat 
	;
jump_stat	:  CONTINUE ';'
	| BREAK ';'
	| RETURN exp ';'
	| RETURN ';'
	;




exp	: assignment_exp 
	| exp ',' assignment_exp
	;
assignment_exp	: logical_or_exp
	| unary_exp assignment_operator assignment_exp	
	;
assignment_operator	: PUNC
	| '='
	;
logical_or_exp	: logical_and_exp
	| logical_or_exp OR logical_and_exp
	;
logical_and_exp	: inclusive_or_exp
	| logical_and_exp AND inclusive_or_exp
	;
inclusive_or_exp	: exclusive_or_exp
	| inclusive_or_exp '|' exclusive_or_exp
	;
exclusive_or_exp	: and_exp
	| exclusive_or_exp '^' and_exp
	;
and_exp	: equality_exp
	| and_exp '&' equality_exp
	;
equality_exp	: relational_exp
	| equality_exp IS_EQUAL_OR_NOT relational_exp
	;
relational_exp	: additive_exp
	| relational_exp '<' additive_exp
	| relational_exp '>' additive_exp
	| relational_exp S_OR_B_EQ additive_exp
	;
additive_exp	: mult_exp
	| additive_exp '+' mult_exp
	| additive_exp '-' mult_exp
	;
mult_exp	: cast_exp
	| mult_exp '*' cast_exp
	| mult_exp '/' cast_exp
	| mult_exp '%' cast_exp
	;
cast_exp	: unary_exp
	| '(' type_name ')' cast_exp
	;
unary_exp	: postfix_exp
	| INCREMENT unary_exp
	| unary_operator cast_exp
	;
unary_operator	: '&' | '*' | '+' | '-' | '~' | '!' 	
	;
postfix_exp	: primary_exp 	
	| postfix_exp '[' exp ']'
	| postfix_exp '(' argument_exp_list ')'
	| postfix_exp '(' ')'
	| postfix_exp '.' VARIABLE_NAME
	| postfix_exp POINT_CONST VARIABLE_NAME
	| postfix_exp INCREMENT
	;
primary_exp	: VARIABLE_NAME 	
	| consts 	
	| STRING
	| '(' exp ')'
	;
argument_exp_list	: assignment_exp
	| argument_exp_list ',' assignment_exp
	;
consts	: INT_DEF 	
	| CHAR
	| TR_FA
	| FLOAT_DEF
	;
%% 

int main()
{
    yyparse();
    if(success)
    	printf("Parsing Successful\n");
    return 0;
}

int yyerror(const char *msg)
{
	extern int yylineno;
	printf("Line no: %d found error\nError Message: %s\n",yylineno,msg);
	success = 0;
	return 0;
}