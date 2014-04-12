//
//  MapOverlay.m
//  Ossabaw
//
//  Created by Dustin Schie on 4/5/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import "MapOverlay.h"

@implementation MapOverlay

-(CLLocationCoordinate2D) coordinate
{
    return CLLocationCoordinate2DMake(31.79306891109953,-81.09055325388908);
//    return CLLocationCoordinate2DMake(31.804060, -80);
}

-(MKMapRect)boundingMapRect
{
    MKMapPoint  southWest = MKMapPointForCoordinate(CLLocationCoordinate2DMake(31.7172507525542, -81.1534014420626)),
    northEast = MKMapPointForCoordinate(CLLocationCoordinate2DMake( 31.86915851927848, -81.02770506571557));
    
    
//    MKMapRect bounds = MKMapRectMake(southWest.x, southWest.y, fabs(southWest.x - northEast.x), fabs(southWest.y - northEast.y));
        MKMapRect bounds = MKMapRectMake(northEast.x, northEast.y, fabs(southWest.x - northEast.x), fabs(southWest.y - northEast.y));
//    MKMapRect bounds = MKMapRectMake(northEast.x, northEast.y, southWest.x, southWest.y);
    return bounds;
}

@end
