//
//  MapOverlay.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/5/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapOverlay : NSObject <MKOverlay>
{
    CLLocationCoordinate2D coordinate;
}

- (MKMapRect) boundingMapRect;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
