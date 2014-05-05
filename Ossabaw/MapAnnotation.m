//
//  MapAnnotation.m
//  Ossabaw
//
//  Created by Dustin Schie on 4/2/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize title, iconDir, index, coordinate, pinColor;

- (id)initWithLocation:(CLLocationCoordinate2D)coord
{   self = [super init];
    if (self)
        coordinate = coord;
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    coordinate = newCoordinate;
}
@end
