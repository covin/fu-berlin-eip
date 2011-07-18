#include <platform.h>
#include <stdlib.h>

#include "video.h"
#include "test.h"
#include "compress.h"

int main(void) {
    int w=VID_WIDTH;
    int h=VID_HEIGHT;

    streaming chan vid, cmpr, output;
    tst_setup(w,h);

    par {
        tst_run_debug_video(vid);
        cmpr_encoder(vid, cmpr, w, h);
        cmpr_decoder(cmpr, output, w, h);
        //tst_run_dump_stream(cmpr);
        //tst_run_debug_output(output);
        tst_run_frame_statistics(output,w,h);
    }

    return 0;
}
