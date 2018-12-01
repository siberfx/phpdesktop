TARGET=build/bin/phpdesktop

INCLUDES = -Isrc -Lbuild/lib -Lbuild/bin

CCFLAGS = -g -Wall -Werror -std=gnu++11 $(INCLUDES)
CCFLAGS += $(shell pkg-config --cflags glib-2.0 gtk+-3.0)

CFLAGS_OPTIMIZE = -O3 -fvisibility=hidden

LDFLAGS = -Wl,-rpath,. -Wl,-rpath,"\$$ORIGIN" -lX11 -lcef -lcef_dll_wrapper
LDFLAGS += $(shell pkg-config --libs glib-2.0 gtk+-3.0)

OBJS=\
	src/main.o \
	src/app.o \
	src/client_handler.o \

CC=g++
.PHONY: clean release debug

# When switching between debug/release modes always clean
# all objects by executing either "./build.sh clean debug"
# or "./build.sh clean release". Otherwise changes to the
# DEBUG macro are not applied.

release: $(TARGET)

debug: CCFLAGS += -DDEBUG
debug: $(TARGET)

-include $(patsubst %, %.deps, $(OBJS))

%.o : %.cpp
	+$(CC) -c -o $@ -MD -MP -MF $@.deps $(CCFLAGS) $(CFLAGS_OPTIMIZE) $<

$(TARGET): $(OBJS)
	+$(CC) $(CCFLAGS) $(CFLAGS_OPTIMIZE) -o $@ $(OBJS) $(LDFLAGS)

clean:
	rm -f $(OBJS) $(patsubst %, %.deps, $(OBJS)) $(TARGET)