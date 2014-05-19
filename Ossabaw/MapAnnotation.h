//
//  MapAnnotation.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/2/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Journal.h"

@interface MapAnnotation : NSObject<MKAnnotation>
{
    NSString    *tittle;
    NSString    *iconDir;
    CLLocationCoordinate2D coordinate;
    BOOL        hasVistied;
    NSInteger   index;
    Journal     *journal;
    MKPinAnnotationColor pinColor;
                
            
}
@property (nonatomic, copy) NSString    *title;
@property (nonatomic, copy) NSString    *subtitle;
@property (nonatomic, copy) NSString    *iconDir;
@property (strong, nonatomic) Journal     *journal;
@property NSInteger index;
@property MKPinAnnotationColor pinColor;

- (id) initWithLocation: (CLLocationCoordinate2D) coord;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
