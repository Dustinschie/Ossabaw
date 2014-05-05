//
//  MapAnnotation.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/2/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject<MKAnnotation>
{
    NSString    *tittle,
                *iconDir;
    CLLocationCoordinate2D coordinate;
    BOOL        hasVistied;
    NSInteger   index;
                
            
}
@property (nonatomic, copy) NSString    *title;
@property (nonatomic, copy) NSString    *subtitle;
@property (nonatomic, copy) NSString   *iconDir;
@property NSInteger index;
@property MKPinAnnotationColor pinColor;

- (id) initWithLocation: (CLLocationCoordinate2D) coord;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
