//
//  MapOverlayRenderer.m
//  Ossabaw
//
//  Created by Dustin Schie on 4/5/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import "MapOverlayRenderer.h"

@implementation MapOverlayRenderer


- (void) drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context{
    UIImage *image = [UIImage imageNamed:@"map.png"];
    UIImage *newImage = [UIImage imageWithCGImage:image.CGImage
                                            scale:[UIScreen mainScreen].scale
                                      orientation:image.imageOrientation];
    
//    CGImageRef imageReference = [newImage CGImage];
    CGImageRef imageReference = [newImage CGImage];
    
    
    MKMapRect theMapRect = [self.overlay boundingMapRect];
    CGRect theRect = [self rectForMapRect:theMapRect];
    
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, theRect.size.width, 0);
//    CGContextTranslateCTM(context, theRect.size.width, -theRect.size.height);
    CGContextDrawImage(context, theRect, imageReference);
}

@end
