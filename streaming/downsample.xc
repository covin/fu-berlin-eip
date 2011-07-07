#include "video.h"
#include <string.h>

enum PixelType {
    NewFrame,
    NewLine,
    NewPixel,
};

{int, int} read_pixel(int &off, int &data, streaming chanend c_in) {
    if (off==0) {
        c_in :> data;
        if (data == VID_NEW_FRAME) {
            return {0, NewFrame};
        } else if (data == VID_NEW_LINE) {
            return {0, NewLine};
        }
        off = 32;
    }
    off -= 8;
    return {(data >> off) & 0xff, NewPixel};
}

#include <stdio.h>

void downsample(const int n, streaming chanend c_in, streaming chanend c_out) {
    // idea: in each line, sum up n pixel values in a buffer postion
    //       on the n-th line at each n-th pixel, output the downsampled value and clear the buffer position

    int buffer[VID_WIDTH/*/n*/]; // no dynamic memory ... :/

    int x=0; // offset for downsampled buffer
    int col_sw=0; // counter for pixels currently in buffer at position x for the current line
    int row_sw=0; // counter for lines currently in buffer

    vid_init(c_in);

    for (int i=0; i<VID_WIDTH; i++) {
        buffer[i]=0;
    }

    vid_with_frames(c_in) {
        vid_start_frame(c_out);
        row_sw=4;

        vid_with_lines(c_in) {
            int p;
            if (row_sw++ == n) {
                row_sw=1;
                vid_start_line(c_out);
            }
            col_sw=0;
            x=0;

            vid_with_ints(p, c_in) vid_with_bytes(p, c_in) {
                buffer[x] += p;
                if (++col_sw==n) {
                    if (row_sw==n) { // we sumed nxn pixels in buffer[x]
                        vid_put_pixel(c_out, buffer[x]/(n*n));
                        buffer[x] = 0;
                    }
                    x++;
                    col_sw=0;
                }
            }
        }
    }
}