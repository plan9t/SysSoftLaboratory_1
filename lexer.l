/* Flex directives */
%option outfile="flex.c" header-file="flex.h"
%option noyywrap nounput noinput

/* This code is copied verbatim to the .c file generated - includes token defs from bison */
%{
#include "bison.h"
%}

/* Grammar */
%%
0[xX][0-9A-Fa-f]+		{return HEX_VALUE;}
0[bB][01]+				{return BITS_VALUE;}
[0-9]+					{return DEC_VALUE;}
"true"|"false"			{return BOOL_VALUE;}
"bool"					{return BOOL_TYPE;}
"byte"					{return BYTE_TYPE;}
"int"					{return INT_TYPE;}
"uint"					{return UINT_TYPE;}
"long"					{return LONG_TYPE;}
"ulong"					{return ULONG_TYPE;}
"char"					{return CHAR_TYPE;}
"string"				{return STRING_TYPE;}
"custom" 				{return CUSTOM_TYPE; }
"("						{return OP_PARENTH; }
")"						{return CL_PARENTH; }
"["						{return OP_ARRAY; }
"]"						{return CL_ARRAY; }
"{"						{return OP_BLOCK; }
"}"						{return CL_BLOCK; }
"="						{return ASSIGNMENT; }
"**"					{return EXPONENTIATION; }
"*"						{return MULTIPLICATION; }
"/"						{return DIVISION; }
"%"						{return MODULO; }
"+"						{return ADDITION; }
"-"						{return SUBTRACTION; }
"&"						{return BITWISE_AND; }
"|"						{return BITWISE_OR; }
"&&"					{return LOGICAL_AND; }
"||"					{return LOGICAL_OR; }
"<"						{return LESS_THAN; }
">"						{return MORE_THAN; }
"<="					{return LESS_OR_EQUALS; }
">="					{return MORE_OR_EQUALS; }
"=="					{return EQUALITY; }
"!="					{return INEQUALITY; }
"++"					{return UNARY_ADDITION; }
"--"					{return UNARY_SUBTRACTION; }
"if"					{return IF; }
"else"					{return ELSE; }
"while"					{return WHILE; }
"do"					{return DO; }
"break"					{return BREAK; }
";"						{return SEMICOLON; }
[a-zA-Z][a-zA-Z0-9]*	{return IDENTIFIER;}
"\'[^']\'"				{return CHAR_VALUE;}
"\"[^\"\\]*(?:\\.[^\"\\]*)*\""					{return STRING_VALUE; }
[ \t]+					{/* ignore whitespaces */}
\n|\r\n					{/* ignore tabulation */}
.      {printf("Mistery character %s\n", yytext);}
%%