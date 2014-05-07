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
@end

@implementation DropPinMapViewController

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
    
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
    CLLocationCoordinate2D coord;
    NSLog(@"%@", [self location]);
    if ([self location] == nil)
        
        coord = CLLocationCoordinate2DMake(31.839120, -81.092040);
    else{
        CGPoint point = CGPointFromString([self location]);
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
    NSLog(@"%d", tag);
    switch (tag) {
        case 0:
            NSLog(@"%d", tag);
            [[self delegate] dropPinMapViewController:self didAddLocation:[self location]];
            break;
        case 1:
            [[self delegate] dropPinMapViewController:self didAddLocation:nil];
            break;
        default:
            break;
    }
}
- (void) setCoord:(NSString *)aLocation
{
    [self setLocation:aLocation];
    NSLog(@"%@", [self location]);
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
