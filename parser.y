/* Bison Directives */
%output  "bison.c" // Code containing yyparse()
%defines "bison.h" // Header file including token declarations needed by Flex
%parse-param {struct astnode **rootnode} // Adds variables to be passed into yyparse()

/* This section is copied verbatim to the .C file generated */
%code{
#include "flex.h"
#include "ast.h"
/* yyerror() needs the parse-param's defined aswell */
void yyerror (struct astnode **rootnode, char const *s);
}

/* YYLVAL types*/
%union{
  int num;
  char var;
  struct astnode* node;
}


/* Terminal Tokens and Type Declaration */
%token HEX_VALUE BITS_VALUE DEC_VALUE BOOL_VALUE BOOL_TYPE BYTE_TYPE INT_TYPE UINT_TYPE LONG_TYPE ULONG_TYPE CHAR_TYPE STRING_TYPE CUSTOM_TYPE
%token OP_PARENTH CL_PARENTH OP_ARRAY CL_ARRAY OP_BLOCK CL_BLOCK ASSIGNMENT EXPONENTIATION MULTIPLICATION DIVISION MODULO ADDITION SUBTRACTION
%token BITWISE_AND BITWISE_OR LOGICAL_AND LOGICAL_OR LESS_THAN MORE_THAN LESS_OR_EQUALS MORE_OR_EQUALS EQUALITY INEQUALITY
%token UNARY_ADDITION UNARY_SUBTRACTION IF ELSE WHILE DO BREAK SEMICOLON IDENTIFIER CHAR_VALUE STRING_VALUE
%token OF_KEYWORD COMMA

/* Non Terminal Type Declaration */
%type <node> expr

/* Precedence */
%left MULTIPLICATION DIVISION ADDITION SUBTRACTION
%right EXPONENTIATION MODULO
%start source






%%
/* Grammar 4 parser*/
source: 
  sourceItemList
  ;

sourceItemList:
  /*empty for empty list*/
  | sourceItemList sourceItem

typeRef: 
  BOOL_TYPE
  | BYTE_TYPE
  | INT_TYPE
  | UINT_TYPE
  | LONG_TYPE
  | ULONG_TYPE
  | CHAR_TYPE
  | STRING_TYPE
  | custom
  | array
  ;

custom: 
  IDENTIFIER
  ;

array: 
  typeRef ARRAY_TYPE OP_ARRAY DEC_VALUE CL_ARRAY;
  ;

funcSignature:
  IDENTIFIER OP_PARENTH argList CL_PARENTH typeRefOption
  ;

argList:
  arg
  | arg COMMA argList
  ;

arg:
  IDENTIFIER typeRefOption
  ;

typeRefOption:
  /* Empty for no "of" option */
  | OF_KEYWORD typeRef
  ;

sourceItem:
  funcDef
  ;

funcDef: 
  DEF_KEYWORD funcSignature statementList END_KEYWORD
  ;

statementList:
  /*Empty for empty statement list*/
  | statementList statement
  ;

statement:
  if 
  | loop
  | repeat
  | break
  | expression
  | block
  ;

if:
  IF_KEYWORD expr THEN_KEYWORD statement elseStatementOption
  ;
  
elseStatementOption:
  /* Empty for no "else" option */
  | ELSE_KEYWORD statement
  ;

loop:
  WHILE_KEYWORD expr statementList END_KEYWORD
  | UNTIL_KEYWORD expr statementList END_KEYWORD
  ;

repeat:
  statement WHILE_KEYWORD expr SEMICOLON
  | statement UNTIL_KEYWORD expr SEMICOLON
  ;

break:
  BREAK_KEYWORD SEMICOLON
  ;

expression:
  expr SEMICOLON
  ;

block:
  openBlock statementOrSourceItemList closeBlock
  ;


statementOrSourceItemList:
  /*empty*/
  | statementOrSourceItemList statementList sourceItemList
  ;

openBlock:
  BEGIN_KEYWORD
  | OP_BLOCK
  ;

closeBlock:
  END_KEYWORD
  | CL_BLOCK
  ;

// EXPR MODULE. TO BE CONTINIED
expr:
  binary
  | unary
  | braces
  | call
  | slice
  ;

binary:
  expr binOp expr
  ;

binOp:
  ADDITION
  | SUBTRACTION
  | MULTIPLICATION
  | DIVISION
  | MODULO
  | LOGICAL_AND
  | LOGICAL_OR
  | EQUALITY
  | INEQUALITY
  | LESS_THAN
  | MORE_THAN
  | LESS_OR_EQUALS
  | MORE_OR_EQUALS
  | BITWISE_AND
  | BITWISE_OR
  | LEFT_SHIFT
  | RIGHT_SHIFT
  | EXCLUSIVE_OR
  | ASSIGNMENT
  ;

unary:
  unOp expr
  ;

unOp:
  UNARY_ADDITION
  | UNARY_SUBTRACTION
  ;

braces:
  OP_PARENTH expr CL_PARENTH
  ;

call:
  expr OP_PARENTH exprList CL_PARENTH
  ;

exprList:
  expr
  | exprList COMMA expr
  ;

slice:
  expr OP_ARRAY rangeList CL_ARRAY
  ;

rangeList:
  expr
  | rangeList DOUBLE_POINT expr
  ;

place:
  IDENTIFIER
  ;

literal:
  BOOL_VALUE
  | STRING_VALUE
  | CHAR_VALUE
  | HEX_VALUE
  | BITS_VALUE
  | DEC_VALUE
  ;


/*
input
    : expr { *rootnode = $1;}
    ;
 
expr
    : expr[L] ADD expr[R] { $$ = add_node($L, T_ADD, $R); }
    | expr[L] MUL expr[R] { $$ = add_node($L, T_MUL, $R); }
    | OPREN expr[E] CPREN { $$ = $E; }
    | NUMBER { $$ = add_num($1); }
    ;
*/
%%


/* Error handling - this is the default function reccomended by Bison docs */
void yyerror (struct astnode **rootnode, char const *s){ 
	fprintf (stderr, "%s\n", s);
}