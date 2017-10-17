Gram=y.tab.c y.tab.h

all: $(Gram) vector_cal.c
	@gcc -o vector y.tab.c vector_cal.c -lm
	@echo Compiled

vector_cal.c:
	@echo "Si esta"

$(Gram): vector.y
	@yacc -d vector.y
