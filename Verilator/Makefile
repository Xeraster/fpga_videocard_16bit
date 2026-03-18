TOP = video
VERILOG = video.v
CPP = main.cpp

SDL_CFLAGS = $(shell sdl2-config --cflags)
SDL_LIBS = $(shell sdl2-config --libs)

all:
	verilator -Wall -Wno-fatal --cc $(VERILOG) --exe $(CPP) --top-module video \
	-CFLAGS "$(SDL_CFLAGS)" \
	-LDFLAGS "$(SDL_LIBS)"
	make -C obj_dir -f V$(TOP).mk

run: all
	./obj_dir/V$(TOP)

clean:
	rm -rf obj_dir