all: static dynamic static-stripped dynamic-stripped

.PHONEY: clean
clean:
	rm -f static dynamic static-stripped dynamic-stripped


static: main.c
	gcc main.c -o static -static -lcrypto -ldl -lz #-s

static-stripped: static
	cp static static-stripped
	strip -s -R .comment static-stripped

dynamic: main.c
	gcc main.c -o dynamic -lcrypto #-s

dynamic-stripped: dynamic
	cp dynamic dynamic-stripped
	strip -s -R .comment dynamic-stripped


