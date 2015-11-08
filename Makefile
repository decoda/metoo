.PHONY: all skynet clean

PLAT ?= linux
SHARED := -fPIC --shared
LUA_CLIB_PATH ?= luaclib

CFLAGS = -g -O2 -Wall

LUA_CLIB = protobuf log

LUA_BINDING = binding/lua53
LUADIR = ./skynet/3rd/lua

all : skynet

skynet/Makefile :
	git submodule update --init

skynet : skynet/Makefile
	cd skynet && $(MAKE) $(PLAT) && cd ..

all : \
  $(foreach v, $(LUA_CLIB), $(LUA_CLIB_PATH)/$(v).so)

$(LUA_CLIB_PATH) :
	mkdir $(LUA_CLIB_PATH)


$(LUA_CLIB_PATH)/protobuf.so : | $(LUA_CLIB_PATH)
	cd lualib-src/pbc && $(MAKE) lib && cd $(LUA_BINDING) && $(MAKE) && cd ../../../.. && cp lualib-src/pbc/$(LUA_BINDING)/protobuf.so $@

$(LUA_CLIB_PATH)/log.so : lualib-src/lua-log.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -I$(LUADIR) $^ -o $@

clean :
	rm -f $(LUA_CLIB_PATH)/*.so && cd skynet && $(MAKE) clean
	
