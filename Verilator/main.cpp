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

//simulate random pixel data upon startup
void fillRandom(uint16_t *buf, size_t size)
{
    for (size_t i = 0; i < (1 << 19); i++) 
    {
        buf[i] = rand() & 0xFFFF;
    }
}

//fill the vram with a predetermined pattern because doing it via isa cycles takes forever due to slow simulation speed
void fillPattern(uint16_t *buf, size_t size)
{
    int soFar = 0;
    for (size_t i = 0; i < (1 << 19); i++) 
    {
        //buf[i] = rand() & 0xFFFF;
        if (soFar < 30000)
        {
            buf[i] = 0x00FF;
        }
        else if (soFar >= 30000 && soFar < 100000)
        {
            buf[i] = 0xFFFF;
        }
        else
        {
            if ((soFar/8) % 2 == 1)
            {
                buf[i] = 0xF000;
            }
            else
            {
                buf[i] = 0x0FF0;
            }
        }
        soFar++;
    }
}

//the simulated sram chips
uint16_t sram[1 << 19];  // 1M bytes = 512K words (16-bit)

//chatgpt says to call this on every clock cycle but idk
void step_sram(Vvideo* top)
{
    uint32_t addr = top->AV & 0xFFFFF;  // 20-bit mask
    uint32_t word_addr = addr >> 1;       // convert byte → word

    bool ce = top->VRAM_en;
    bool we = top->write_cmd;
    bool oe = top->read_cmd;

    if (ce)
        return;

    if (!we)
    {
        // WRITE
        sram[word_addr] = top->data_out;
    }
    else if (!oe)
    {
        // READ
        top->data_in = sram[word_addr];
    }
}

void isa_io_write(Vvideo* top, uint16_t port, uint16_t data)
{
    // Put address on bus (lower 16 bits)
    top->AV_in = port;

    // Put data on bus
    top->data_in = data;

    // 1. Latch address
    top->BALE = 1;
    top->eval();

    top->pllclk ^= 1; top->eval();
    top->pllclk ^= 1; top->eval();

    // 2. Release BALE
    top->BALE = 0;

    // 3. Assert write (active low)
    top->IOW = 0;
    top->pllclk ^= 1;
    top->eval();
    top->pllclk ^= 1;
    top->eval();
    top->pllclk ^= 1;
    top->eval();
    top->pllclk ^= 1;
    top->eval();

    top->pllclk ^= 1; top->eval();
    top->pllclk ^= 1; top->eval();
    top->pllclk ^= 1; top->eval();
    top->pllclk ^= 1; top->eval();
    top->pllclk ^= 1; top->eval();
    top->pllclk ^= 1; top->eval();
    top->pllclk ^= 1; top->eval();
    top->pllclk ^= 1; top->eval();
    top->pllclk ^= 1; top->eval();
    top->pllclk ^= 1; top->eval();
    top->pllclk ^= 1; top->eval();

    // 4. Deassert write
    top->IOW = 1;
    top->pllclk ^= 1;
    top->eval();
    top->pllclk ^= 1;
    top->eval();
    top->pllclk ^= 1;
    top->eval();
    top->pllclk ^= 1;
    top->eval();
}

void set_vram_addr(Vvideo* top, uint32_t addr)
{
    isa_io_write(top, 0x428, addr & 0xFFFF);
    isa_io_write(top, 0x42A, (addr >> 16) & 0xFF);
}

void write_pixel(Vvideo* top, uint16_t value)
{
    isa_io_write(top, 0x42C, value);
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

    memset(sram, 0, sizeof(sram));
    //fillRandom(sram, sizeof(sram));
    fillPattern(sram, sizeof(sram));

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

    static int delay = 0;
    static int writes_done = 0;

    while(!Verilated::gotFinish())
    {
        while(SDL_PollEvent(&event)){
            if(event.type == SDL_QUIT)
                return 0;
        }

        //set all the isa signals to make it so there's 100% no isa cycle right now
        top->BALE = 0;
        top->MEMW = 1;
        top->MEMR = 1;
        top->SMEMW = 1;
        top->SMEMR = 1;
        top->IOW = 1;
        top->IOR = 1;

        /* clock */
        top->pllclk ^= 1;
        top->ISACLK = 0;    //just don't use the isa clock since it doesn't really get used that much anymore
        top->eval();

        step_sram(top);
        //top->data_in = sram[55555];
        //top->data_in = 0xFFFF;

        static bool last_pixel = 0;
        bool pixel = top->pixelClock;

        //if(top->pixelClock)
        if (pixel && !last_pixel)
        {
            /* draw pixel only when valid */
            if (top->VALID_PIXELS)
            {
                int x = top->horizontalCount;
                int y = top->verticalCount;

                if (x < 640 && y < 480)
                {
                    int idx = (y * 640 + x) * 3;

                    /* convert 5-6-5 to 8-bit */
                    framebuffer[idx + 0] = (top->Red << 3);
                    framebuffer[idx + 1] = (top->Green << 2);
                    framebuffer[idx + 2] = (top->Blue << 3);
                }
            }

            //countdown delay 
            if (delay > 0)
            {
                delay--;
            }
            else if (writes_done < 10000)
            {
                // pick random address + write
                uint32_t addr = rand() % (640 * 480 * 2);

                //set_vram_addr(top, addr);
                //write_pixel(top, 0xFFFF);

                //simulate keyboard cycles and see if it causes glitch
                //isa_io_write(top, 0x423, 0x6060);
                isa_io_write(top, 0x60, 0x6060);

                writes_done++;

                // random delay before next write
                delay = rand() % 50; // tweak this
            }

            // reset each frame
            if (!top->VSYNC && last_vsync)
            {
                writes_done = 0;
            }
            /* detect start of frame */
            if (!top->VSYNC && last_vsync)
            {
                SDL_UpdateTexture(texture, NULL, framebuffer, 640 * 3);
                SDL_RenderClear(renderer);
                SDL_RenderCopy(renderer, texture, NULL, NULL);
                SDL_RenderPresent(renderer);
            }

            last_vsync = top->VSYNC;
        }

        last_pixel = pixel;
    }
}