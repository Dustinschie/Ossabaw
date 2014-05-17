//
//  DropPinMapViewController.m
//  Ossabaw
//
//  Created by Dustin Schie on 5/2/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import "DropPinMapViewController.h"

@interface DropPinMapViewController ()
@property (strong, nonatomic) NSString* location;
@property (strong, nonatomic) NSString* previousLocation;
@end

@implementation DropPinMapViewController
@synthesize mapOverlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self mapView] setDelegate:self];
    // Do any additional setup after loading the view.
    [[self segControl] addTarget:self
                          action:@selector(changeMap:)
                forControlEvents:UIControlEventValueChanged];
    [[[self toolBar] layer] setMasksToBounds:YES];
    [[[self toolBar] layer] setCornerRadius:5];
    
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setMapOverlay: [[MapOverlay alloc] init]];
    
    CLLocationCoordinate2D location = [mapOverlay coordinate];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.15084913077129, 0.12569636106491);
    //    MKCoordinateRegion region = MKCoordinateRegionForMapRect([mapOverlay boundingMapRect]);
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    //    MKCoordinateRegion region = MKCoordinateRegionForMapRect([mapOverlay boundingMapRect]);
    
    //    [self mapView]
    
    [[self mapView] setRegion:region animated:NO];


    
    CLLocationCoordinate2D coord;
    if ([self previousLocation] == nil)
        coord = CLLocationCoordinate2DMake(31.839120, -81.092040);
    else{
        CGPoint point = CGPointFromString([self previousLocation]);
        coord = CLLocationCoordinate2DMake(point.x, point.y);
    }
    
    [self setPin:[[MapAnnotation alloc] initWithLocation:coord]];
    
    [[self mapView] addAnnotation:[self pin]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)changeMap:(id)sender
{
    switch ([[self segControl] selectedSegmentIndex]) {
        case 0:
            [[self mapView] setMapType:MKMapTypeStandard];
            break;
        case 1:
            [[self mapView] setMapType:MKMapTypeHybrid];
            break;
        case 2:
            [[self mapView] setMapType:MKMapTypeSatellite];
            break;
        default:
            break;
    }
    
}
-(IBAction)dismiss:(id)sender
{
    NSInteger tag = [sender tag];
    NSLog(@"%d %@ %@", tag, [self location], [self previousLocation]);
    switch (tag) {
        case 0:
            
            [[self delegate] dropPinMapViewController:self didAddLocation:[self location]];
            break;
        case 1:
            
            [[self delegate] dropPinMapViewController:self didAddLocation:[self previousLocation]];
            break;
        default:
            break;
    }
}
- (void) setCoord:(NSString *)aLocation
{
    [self setPreviousLocation:aLocation];
}
#pragma mark - MKMapViewDelegate
- (void)    mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
 didChangeDragState:(MKAnnotationViewDragState)newState
       fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding) {

        CLLocationCoordinate2D droppedAt = [[view annotation] coordinate];
        CGPoint point = CGPointMake(droppedAt.latitude, droppedAt.longitude);
        [self setLocation:NSStringFromCGPoint(point)];
    }
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass: [MapAnnotation class]]){
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[[self mapView] dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView) {

            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
        }
        [pinView setPinColor:MKPinAnnotationColorGreen];
        [pinView setAnimatesDrop: YES];
        [pinView setDraggable:YES];

        
        return pinView;
        
    }
    return nil;
}


@end
