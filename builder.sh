cc $@ main.c -o main
v=$(cc --version | head -n1)
t=$(./main)

echo $v"|"$t"|"$@
