//
//  DropPinMapViewController.h
//  Ossabaw
//
//  Created by Dustin Schie on 5/2/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapOverlay.h"
#import "MapAnnotation.h"
@protocol AddPinDelegate;

@interface DropPinMapViewController : UIViewController<MKMapViewDelegate>
{
    MKMapView *mapView;
    UIToolbar *cancelButton;
    UIToolbar *doneButton;
    UISegmentedControl *segControl;
    UIToolbar *toolBar;
    id<AddPinDelegate> delegate;
    MapAnnotation *pin;
    MapOverlay *mapOverlay;
}
@property (strong, nonatomic)           IBOutlet    MKMapView           *mapView;
@property (strong, nonatomic)           IBOutlet    UIToolbar           *cancelButton;
@property (strong, nonatomic)           IBOutlet    UIToolbar           *doneButton;
@property (strong, nonatomic)           IBOutlet    UISegmentedControl  *segControl;
@property (strong, nonatomic)           IBOutlet    UIToolbar           *toolBar;
@property (unsafe_unretained, nonatomic)            id<AddPinDelegate>  delegate;
@property (strong, nonatomic)                       MapAnnotation       *pin;
@property (strong, nonatomic)                       MapOverlay          *mapOverlay;


-(IBAction)changeMap:(id)sender;
-(IBAction)dismiss:(id)sender;
- (void) setCoord:(NSString *)aLocation;
@end

@protocol AddPinDelegate <NSObject>

- (void) dropPinMapViewController: (DropPinMapViewController *)dropPinMapViewController
                   didAddLocation: (NSString *)location;

@end