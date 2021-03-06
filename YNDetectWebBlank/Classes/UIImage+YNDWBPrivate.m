//
//  UIImage+YNDWBPrivate.m
//  YNDetectWebBlank
//
//  Created by Wang Ya on 14/3/19.
//  Copyright © 2019 Wang Ya. All rights reserved.
//

#import "UIImage+YNDWBPrivate.h"

@implementation UIImage (YNDWB)

// TODO: Is it possible to improve performance?
// refer: https://stackoverflow.com/a/30732543/9315497
// TODO: Use GPU
- (BOOL)yndwb_isBlank
{
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

    CGImageRef image = self.CGImage;
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    GLubyte * imageData = malloc(width * height * 4);
    int bytesPerPixel = 4;
    size_t bytesPerRow = bytesPerPixel * width;
    int bitsPerComponent = 8;
    CGContextRef imageContext =
    CGBitmapContextCreate(
                          imageData, width, height, bitsPerComponent, bytesPerRow, CGImageGetColorSpace(image),
                          kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big
                          );
    
    CGContextSetBlendMode(imageContext, kCGBlendModeCopy);
    CGContextDrawImage(imageContext, CGRectMake(0, 0, width, height), image);
    CGContextRelease(imageContext);
    
    int byteIndex = 0;
    
    BOOL imageExist = YES;
    for ( ; byteIndex < width*height*4; byteIndex += 4) {
        CGFloat red = ((GLubyte *)imageData)[byteIndex]/255.0f;
        CGFloat green = ((GLubyte *)imageData)[byteIndex + 1]/255.0f;
        CGFloat blue = ((GLubyte *)imageData)[byteIndex + 2]/255.0f;
        CGFloat alpha = ((GLubyte *)imageData)[byteIndex + 3]/255.0f;
        if( red != 1 || green != 1 || blue != 1 || alpha != 1 ){
            imageExist = NO;
            break;
        }
    }
    
    CFAbsoluteTime detectTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"YNDetectWebBlank UIImage yndwb_isBlank time: %0.2fms", detectTime * 1000.0);
    return imageExist;
}

@end
