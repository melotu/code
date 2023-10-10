%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#ifndef YYSTYPE
#define YYSTYPE char*// 如果未定义 YYSTYPE，则将其定义为 char* 类型
#endif
char idStr[50];// 存储标识符字符串的数组
char numStr[50];// 存储数字字符串的数组
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char*s);
%}

%token NUMBER
%token ID
%token ADD
%token SUB
%token MUL
%token LEF  //(
%token RIG  //)
%token DIV
%left ADD SUB
%left MUL DIV
%right UMINUS

%%

lines   :  lines expr '\n' {printf("%s\n",$2); }
        |  lines '\n'
        |
        ;

expr    :   expr ADD expr  {$$=(char *)malloc(50*sizeof(char));strcpy  ($$,$1); strcat($$,$3); strcat($$,"+ ");}
        |   expr SUB expr  {$$=(char *)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,$3); strcat($$,"- ");}
        |   LEF expr RIG  {$$=(char* )malloc(50*sizeof(char)); strcpy($$,$2);}
        |   expr MUL expr  {$$=(char *)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,$3); strcat($$,"* ");}
        |   expr DIV expr  {$$=(char *)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,$3); strcat($$,"/ ");}
        |   SUB expr %prec UMINUS  {$$=(char*)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$,"- ");}
        |   NUMBER  {$$=(char *)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$," ");}
        |   ID  {$$=(char*)malloc(50*sizeof(char)); strcpy($$,$1); strcat($$," ");}


%%

//programs section

int yylex()
{
    int t;
    while(1)
    {
        t=getchar();
        if(t==' '||t=='\t')
        {

        }
        else if(isdigit(t))
        {
            int num=0;
            while(isdigit(t))
            {
                numStr[num]=t;
                num++;
                t=getchar();
            }
            numStr[num]='\0';
            yylval=numStr;//将识别的数字传递给语法分析器。
            ungetc(t,stdin);
            return NUMBER;
        }
        else if(t=='+')
        {
            return ADD;
        }
        else if(t=='-')
        {
            return SUB;
        }
        else if(t=='*')
        {
            return MUL;
        }
        else if(t=='/')
        {
            return DIV;
        }
        else if(t=='(')
        {
            return LEF;
        }
        else if(t==')')
        {
            return RIG;
        }
        else
        {
            return t;
        }
    }
}

int main(void)
{
    yyin = stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
void yyerror(const char*s){
    fprintf(stderr, "Parse error: %s\n",s);
    exit(1);
}