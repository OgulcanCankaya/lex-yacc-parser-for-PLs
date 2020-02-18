lexfile= project.l
yaccfile = project.y
make:	
	lex $(lexfile)
	yacc -dv $(yaccfile)
	gcc -o a.out y.tab.c lex.yy.c -lfl -lm
	gcc -o ex0 lex.yy.c -lfl