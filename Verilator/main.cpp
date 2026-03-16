//#include "Vvideo.h"
#include <verilated.h>
#include <SDL2/SDL.h>

int main() {

    Vvideo *top = new Vvideo;

    SDL_Init(SDL_INIT_VIDEO);

    SDL_Window *window = SDL_CreateWindow(
        "FPGA Video",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        640,480,0);

    SDL_Renderer *renderer = SDL_CreateRenderer(window,-1,0);
    SDL_Texture *texture =
        SDL_CreateTexture(renderer,
                          SDL_PIXELFORMAT_RGB24,
                          SDL_TEXTUREACCESS_STREAMING,
                          640,480);

    uint8_t framebuffer[640*480*3];

    int x=0;
    int y=0;

    while(!Verilated::gotFinish()) {

        top->clk = !top->clk;
        top->eval();

        if(top->clk) {

            if(!top->hsync) x = 0;

            if(!top->vsync) {
                y = 0;
                SDL_UpdateTexture(texture,NULL,framebuffer,640*3);
                SDL_RenderCopy(renderer,texture,NULL,NULL);
                SDL_RenderPresent(renderer);
            }

            framebuffer[(y*640 + x)*3 + 0] = top->r;
            framebuffer[(y*640 + x)*3 + 1] = top->g;
            framebuffer[(y*640 + x)*3 + 2] = top->b;

            x++;

            if(x==640){
                x=0;
                y++;
            }
        }
    }
}
