//
//  FirstViewController.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/1/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "MapAnnotation.h"
#import "PlaceViewController.h"
#import "MapOverlay.h"
#import "MapOverlayRenderer.h"
#import "JournalViewController.h"
#import "Journal.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, NSFetchedResultsControllerDelegate>
{
    MKMapView* mapView;
    UIToolbar* toolBar;
    MKUserLocation* userLocation;
    NSArray   *places;
    MapOverlay *mapOverlay;
    BOOL hasOpened;
}
@property (strong, nonatomic) IBOutlet  UISegmentedControl              *segControl;
@property (strong, nonatomic) IBOutlet  MKMapView                       *mapView;
@property (strong, nonatomic)           NSManagedObjectContext          *managedObjectContext;
@property (strong, nonatomic)           NSFetchedResultsController      *fetchedResultsController;
@property                               NSArray                         *places;
@property                               MKUserLocation                  *userLocation;
@property (strong, nonatomic)           MapOverlay                      *mapOverlay;
@property (strong, nonatomic)           NSMutableArray                  *journals;
@property                               NSInteger                        index;
-(IBAction)changeMap:(id)sender;

-(CLLocationCoordinate2D) getCoordinateFromMapRectanglePoint: (double)x  y: (double) y;
-(NSArray *)getBoundingBox: (MKMapRect)mRect;
-(CLLocationCoordinate2D)getNECoordinate:(MKMapRect)mRect;
-(CLLocationCoordinate2D)getNWCoordinate:(MKMapRect)mRect;
-(CLLocationCoordinate2D)getSECoordinate:(MKMapRect)mRect;
-(CLLocationCoordinate2D)getSWCoordinate:(MKMapRect)mRect;

@end
