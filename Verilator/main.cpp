#include "Vvideo.h"
#include <verilated.h>
#include <SDL2/SDL.h>
#include <cstring>

//simulate random pixel data upon startup
void fillRandom(uint8_t *buf, size_t size)
{
    for(size_t i = 0; i < size; i++)
        buf[i] = rand() & 0xFF;
}

int main(int argc, char** argv)
{
    Verilated::commandArgs(argc, argv);

    Vvideo *top = new Vvideo;

    SDL_Init(SDL_INIT_VIDEO);

    SDL_Window *window = SDL_CreateWindow(
        "FPGA VGA",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        640,480,0);

    SDL_Renderer *renderer = SDL_CreateRenderer(window,-1,0);

    SDL_Texture *texture = SDL_CreateTexture(
        renderer,
        SDL_PIXELFORMAT_RGB24,
        SDL_TEXTUREACCESS_STREAMING,
        640,480);

    uint8_t framebuffer[640*480*3];
    memset(framebuffer,0,sizeof(framebuffer));
    fillRandom(framebuffer, sizeof(framebuffer));

    SDL_Event event;

    //defaults or whatever
    top->BALE = 0;

    /* reset */
    top->pllclk = 0;
    top->RESET = 0;

    for(int i=0;i<10;i++){
        top->pllclk ^= 1;
        top->eval();
    }

    top->RESET = 1;

    bool last_vsync = 1;

    while(!Verilated::gotFinish())
    {
        while(SDL_PollEvent(&event)){
            if(event.type == SDL_QUIT)
                return 0;
        }

        /* clock */
        top->pllclk ^= 1;
        top->eval();

        if(top->pixelClock)
        {
            /* draw pixel only when valid */
            if(top->VALID_PIXELS)
            {
                int x = top->horizontalCount;
                int y = top->verticalCount;

                if(x < 640 && y < 480)
                {
                    int idx = (y*640 + x)*3;

                    /* convert 5-6-5 to 8-bit */
                    framebuffer[idx+0] = (top->Rt << 3);
                    framebuffer[idx+1] = (top->Gt << 2);
                    framebuffer[idx+2] = (top->Bt << 3);
                }
            }

            /* detect start of frame */
            if(!top->VSYNC && last_vsync)
            {
                SDL_UpdateTexture(texture,NULL,framebuffer,640*3);
                SDL_RenderClear(renderer);
                SDL_RenderCopy(renderer,texture,NULL,NULL);
                SDL_RenderPresent(renderer);
            }

            last_vsync = top->VSYNC;
        }
    }
}