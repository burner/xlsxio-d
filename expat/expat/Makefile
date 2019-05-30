SRCS:= lib/loadlibrary.c \
lib/xmlparse.c \
lib/xmlrole.c \
lib/xmltok.c \
lib/xmltok_impl.c \
lib/xmltok_ns.c \
lib/xmlparse.c

OBJS := $(patsubst %.c, %.o, $(SRCS))

libexpat.a: $(OBJS)
	ar rcs libexpat.a $(OBJS)

%.o: %.c
	gcc -DHAVE_GETRANDOM -Ilib -c $< -o $@
