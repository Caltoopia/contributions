/*
 * Copyright (c) Ericsson AB, 2013
 * Author: Per Persson (per.persson@ericsson.com)
 *         Harald Gustafsson (harald.gustafsson@ericsson.com)
 * All rights reserved.
 *
 * License terms:
 *
 * Redistribution and use in source and binary forms,
 * with or without modification, are permitted provided
 * that the following conditions are met:
 *     * Redistributions of source code must retain the above
 *       copyright notice, this list of conditions and the
 *       following disclaimer.
 *     * Redistributions in binary form must reproduce the
 *       above copyright notice, this list of conditions and
 *       the following disclaimer in the documentation and/or
 *       other materials provided with the distribution.
 *     * Neither the name of the copyright holder nor the names
 *       of its contributors may be used to endorse or promote
 *       products derived from this software without specific
 *       prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "HFVView.h"

@implementation HFVView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    long width=0, height=0;

    FILE *fd = fopen("/tmp/drawingsize","r");
    if(fd) {
        char line[16];
        char* p = fgets(line, 16, fd);
        if(p!=NULL)
            width = atol(line);
        p = fgets(line, 16, fd);
        if(p!=NULL)
            height = atol(line);
        fclose(fd);
    }
    NSBitmapImageRep* offscreenRep = nil;
    unsigned char *data= malloc(width*height*4*sizeof(char));
    
    
    
    
    // Draw your content...
    fd = fopen("/tmp/drawing","rb");
    if(fd) {
        size_t l = fread(data, 4*sizeof(char), width*height, fd);
        fclose(fd);
    } else {
        for(int x=0;x<width*height*4*sizeof(char);x++){
            data[x] = 0xaa;
        }
    }
    
    offscreenRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&data
                                                           pixelsWide:width
                                                           pixelsHigh:height
                                                        bitsPerSample:8
                                                      samplesPerPixel:4
                                                             hasAlpha:YES
                                                             isPlanar:NO
                                                       colorSpaceName:NSDeviceRGBColorSpace
                                                         bitmapFormat:0
                                                          bytesPerRow:(4 * width)
                                                         bitsPerPixel:32];
    [offscreenRep draw];
    free(data);
}

@end
