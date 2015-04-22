all:
	gcc -o fibo fibo.c -I/usr/include/libpurple -I/usr/lib/glib-2.0/include -I/usr/include/glib-2.0 -lpurple -lglib-2.0
