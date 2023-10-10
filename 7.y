%{
/*********************************************
将所有的词法分析功能均放在 yylex 函数内实现，为 +、-、*、\、(、 ) 每个运算符及整数分别定义一个单词类别，在 yylex 内实现代码，能
识别这些单词，并将单词类别返回给词法分析程序。
实现功能更强的词法分析程序，可识别并忽略空格、制表符、回车等
空白符，能识别多位十进制整数。
YACC file
**********************************************/
#include<stdio.h>
#include<stdlib.h>
#include<ctype.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

//TODO:给每个符号定义一个单词类别
%token ADD MINUS
%token NUMBER
%token MUL DIV
%token LEF RIG
%left ADD MINUS
%right UMINUS         

%%


lines   :       lines expr ';' { printf("%f\n", $2); }
        |       lines ';'
        |
        ;
//TODO:完善表达式的规则
expr    :       expr ADD expr   { $$=$1+$3; }
        |       expr MINUS expr   { $$=$1-$3; }
        |       expr MUL expr   { $$=$1*$3; }
        |       expr DIV expr   { $$=$1/$3; }
        |       LEF expr RIG    { $$=$2; }
        |       MINUS expr %prec UMINUS   { $$=-$2; }
        |       NUMBER  {$$=$1;}
        ;

%%

// programs section

int yylex()
{
    int t;
    int num=0;
    while(1){
        t=getchar();
        if(t==' '||t=='\t'||t=='\n'){
            //do noting
        }else if(isdigit(t)){
            num=t-'0';
            while(isdigit(t=getchar()))
            {
                num=num*10+t-'0';
            }
            yylval=num;
            ungetc(t, stdin);
            return NUMBER;
            //TODO:解析多位数字返回数字类型 
        }else if(t=='+'){
            return ADD;
        }else if(t=='-'){
            return MINUS;
        }else if(t=='*')
        {
            return MUL;
        }else if(t=='/')
        {
            return DIV;
        }else if(t=='(')
        {
            return LEF;
        }else if(t==')')
        {
            return RIG;
        }else{
            return t;
        }
    }
}

int main(void)
{
    yyin=stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
void yyerror(const char* s){
    fprintf(stderr,"Parse error: %s\n",s);
    exit(1);
}