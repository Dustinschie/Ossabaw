//
//  FirstViewController.m
//  Ossabaw
//
//  Created by Dustin Schie on 4/1/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@end

@implementation MapViewController
@synthesize mapView, userLocation, places, mapOverlay, journals;

- (void)viewDidLoad
{
//    mapView.showsUserLocation = YES;
    [super viewDidLoad];
    hasOpened = NO;
    [[self mapView] setDelegate:self];

    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"Places" ofType:@"plist"];
    places = [NSDictionary dictionaryWithContentsOfFile:filePath][@"places"];

    
    [[self mapView] setZoomEnabled:YES];
    [[self mapView] setPitchEnabled:NO];
    [[self mapView] setRotateEnabled:NO];
    
    
    //    [[self mapView] setScrollEnabled:NO];
//    [[[self mapView] layer] setCornerRadius:5];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[self mapView] removeAnnotations:[[self mapView] annotations]];
    hasOpened = YES;
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    mapOverlay = [[MapOverlay alloc] init];
    
    //    [[self mapView] addOverlay:mapOverlay];
    
    CLLocationCoordinate2D location = [mapOverlay coordinate];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.15084913077129, 0.12569636106491);
    //    MKCoordinateRegion region = MKCoordinateRegionForMapRect([mapOverlay boundingMapRect]);
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    //    MKCoordinateRegion region = MKCoordinateRegionForMapRect([mapOverlay boundingMapRect]);
    
//    [self mapView]
    
    [[self mapView] setRegion:region animated:NO];

    for (int i = 0; i < [[self places] count]; i++) {
        NSDictionary *place = [[self places] objectAtIndex:i];
        CGPoint pt = CGPointFromString(place[@"Location"]);
        MapAnnotation *temp = [[MapAnnotation alloc] initWithLocation: CLLocationCoordinate2DMake(pt.x, pt.y)];
        [temp setTitle: place[@"Name"]];
        [temp setPinColor:MKPinAnnotationColorPurple];
        [temp setSubtitle:place[@"Information"]];
        [temp setIconDir: place[@"Icon"]];
        [temp setIndex: i];
        [[self mapView] addAnnotation:temp];
    }

//    NSLog(@"%d hello", [[[self fetchedResultsController] fetchedObjects] count]);
//    int i = 0;
//    for (Journal *journal in [[self fetchedResultsController] fetchedObjects]) {
//        NSString *location = [journal location];
//        if ([location length] > 0) {
//            CGPoint pt = CGPointFromString([journal location]);
//            MapAnnotation *temp = [[MapAnnotation alloc] initWithLocation:CLLocationCoordinate2DMake(pt.x, pt.y)];
//            [temp setTitle:[journal title]];
//            [temp setPinColor:MKPinAnnotationColorGreen];
//            [temp setSubtitle:[journal information]];
//            [temp setIndex:i];
//            i++;
//            [[self journals] addObject:journals];
//            [[self mapView] addAnnotation:temp];
//            
//        }
//
//    }

    
}


//----------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{   [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----------------------------------------------------------------------------------------------
-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{

    if ([annotation isKindOfClass: [MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass: [MapAnnotation class]]){

        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[[self mapView] dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView) {
            NSLog(@"annotation");
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
        }
        [pinView setAnimatesDrop: !hasOpened];
        MapAnnotation *anAnnotation = (MapAnnotation *) annotation;
        [pinView setPinColor:[anAnnotation pinColor]];
        [pinView setCanShowCallout: YES];
        
        UIButton * button = [UIButton buttonWithType: UIButtonTypeInfoLight];
        [button addTarget:nil action:nil forControlEvents: UIControlEventTouchUpInside];
        
        [pinView setRightCalloutAccessoryView: button];
        UIImage *image;
        if ([[anAnnotation iconDir] length] > 0) {
            image = [UIImage imageNamed: [anAnnotation iconDir]];
        } else{
            NSLog(@"hello");
//            image = [[journals objectAtIndex: [anAnnotation index]] icon];
        }

        CGRect resizeRect;
        resizeRect.size.height = image.size.height / 3;
        resizeRect.size.width = image.size.width   / 3;
        resizeRect.origin = (CGPoint){0,0};
        
        UIGraphicsBeginImageContext(resizeRect.size);
        [image drawInRect:resizeRect];
        UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIImageView *imageView = [[UIImageView alloc] initWithImage:resizedImage];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
//        [imageView setImage:image];
        [pinView setLeftCalloutAccessoryView: imageView];
        UIGraphicsEndImageContext();
        
        
        return pinView;

    }
    return nil;
}

//----------------------------------------------------------------------------------------------
-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
                    calloutAccessoryControlTapped:(UIControl *)control
{
        id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        MapAnnotation *thisAnnotation = annotation;
        
        [self setIndex:[thisAnnotation index]];
        
        [self performSegueWithIdentifier:@"goToInfo" sender:[places objectAtIndex:[thisAnnotation index]]];
        
    }
//    MKMapRect mRect = self.mapView.visibleMapRect;
//    NSArray *temp = [self getBoundingBox:mRect];
//    NSLog(@"%@", temp);
//    CGSize size = [[self mapView] bounds].size;
//    NSLog(@"%f\n%f", size.width, size.height);
}


//----------------------------------------------------------------------------------------------
-(MKOverlayRenderer *) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    return [[MapOverlayRenderer alloc] initWithOverlay:overlay];
//    return [[MKOverlayRenderer alloc] initWithOverlay:overlay];
    
//    return nil;
    
}


//----------------------------------------------------------------------------------------------
-(NSArray *)getBoundingBox: (MKMapRect)mRect
{
    CLLocationCoordinate2D bottomLeft = [self getSWCoordinate:mRect];
    CLLocationCoordinate2D topRight = [self getNECoordinate:mRect];

    return @[ [NSNumber numberWithDouble:bottomLeft.latitude],
              [NSNumber numberWithDouble:bottomLeft.longitude],
              [NSNumber numberWithDouble:topRight.latitude],
              [NSNumber numberWithDouble:topRight.longitude]];

}
-(CLLocationCoordinate2D) getCoordinateFromMapRectanglePoint: (double)x  y: (double) y
{
    MKMapPoint swMapPoint = MKMapPointMake(x,y);
    return MKCoordinateForMapPoint(swMapPoint);
}

-(CLLocationCoordinate2D)getNECoordinate:(MKMapRect)mRect
{
    return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMaxX(mRect) y:mRect.origin.y];
}
-(CLLocationCoordinate2D)getNWCoordinate:(MKMapRect)mRect
{
    return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMinX(mRect) y:mRect.origin.y];
}
-(CLLocationCoordinate2D)getSECoordinate:(MKMapRect)mRect
{
    return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMaxX(mRect) y:MKMapRectGetMaxY(mRect)];
}
-(CLLocationCoordinate2D)getSWCoordinate:(MKMapRect)mRect
{
    return [self getCoordinateFromMapRectanglePoint:mRect.origin.x y:MKMapRectGetMaxY(mRect)];
}


//----------------------------------------------------------------------------------------------
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        if ([[segue identifier] isEqualToString:@"goToInfo"]) {
            JournalViewController *jvc = (JournalViewController *)segue.destinationViewController;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary: (NSDictionary *) sender];
            [jvc setPlace: dict];
            
        }
    
        else if ([[segue identifier] isEqualToString:@"toInfo"]) {
            JournalViewController *jvc = (JournalViewController *)segue.destinationViewController;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary: [places objectAtIndex:[self index]]];
            [jvc setPlace: dict];
        
        }
   
}

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

@end
