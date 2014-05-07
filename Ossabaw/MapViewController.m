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
@synthesize mapView, userLocation, places, mapOverlay, journals, segControl;

- (void)viewDidLoad
{
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setManagedObjectContext:[appDelegate managedObjectContext]];
    
//    mapView.showsUserLocation = YES;
    [super viewDidLoad];
    hasOpened = NO;
    [[self mapView] setDelegate:self];

    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"Places" ofType:@"plist"];
    places = [NSDictionary dictionaryWithContentsOfFile:filePath][@"places"];

    
    [[self mapView] setZoomEnabled:YES];
    [[self mapView] setPitchEnabled:NO];
    [[self mapView] setRotateEnabled:NO];
    [[[self segControl] layer] setCornerRadius:5];
    
    
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
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    mapOverlay = [[MapOverlay alloc] init];
    
    [[self mapView] addOverlay:mapOverlay];
    
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
}


//----------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{   [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----------------------------------------------------------------------------------------------
-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
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
        if ([anAnnotation journal] == nil) {
            if ([[anAnnotation iconDir] length] > 0) {
//                image = [UIImage imageNamed: [anAnnotation iconDir]];
                image = [UIImage imageWithCGImage:[UIImage imageNamed:[anAnnotation iconDir]].CGImage
                                            scale:2.5
                                      orientation:UIImageOrientationUp];
            } else{
                NSLog(@"iconDir is empty!");
            }
        }else{
            
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
        CGRect rect = [imageView frame];
        [imageView setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, [pinView  frame].size.height)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [pinView setLeftCalloutAccessoryView: imageView];
        [[[pinView leftCalloutAccessoryView] layer] setMasksToBounds:YES];
        [[[pinView leftCalloutAccessoryView] layer] setCornerRadius:5];
    
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
//-(MKOverlayRenderer *) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
//{
//    return [[MapOverlayRenderer alloc] initWithOverlay:overlay];
////    return [[MKOverlayRenderer alloc] initWithOverlay:overlay];
//    
////    return nil;
//    
//}


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

- (void) configureAnnotations
{
    [[self mapView] removeAnnotations:[[self mapView] annotations]];
    for (Journal * journal in [[self fetchedResultsController] fetchedObjects]) {
        MapAnnotation *annotation = [[MapAnnotation alloc] init];
        [annotation setJournal:journal];
        [annotation setPinColor:MKPinAnnotationColorGreen];
        [[self mapView] addAnnotation:annotation];
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    // Set up the fetched results controller if needed.
    if (_fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Journal"
                                                  inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                                 initWithFetchRequest:fetchRequest
                                                                 managedObjectContext:[self managedObjectContext]
                                                                 sectionNameKeyPath:nil
                                                                 cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        [self setFetchedResultsController: aFetchedResultsController];
    }
//	[self configureAnnotations];
	return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            [self fetchedResultsChangeInsert:anObject];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [self fetchedResultsChangeDelete:anObject];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            [self fetchedResultsChangeUpdate:anObject];
            break;
        }
        case NSFetchedResultsChangeMove:
            break;
        default:
            break;
    }
}

- (void)fetchedResultsChangeInsert: (MapAnnotation *)annotation
{
    [[self mapView] addAnnotation:annotation];
}
- (void)fetchedResultsChangeDelete: (MapAnnotation *)annotation
{
    [[self mapView] removeAnnotation:annotation];
}
- (void)fetchedResultsChangeUpdate: (MapAnnotation *)annotation
{
    [self fetchedResultsChangeDelete:annotation];
    [self fetchedResultsChangeInsert:annotation];
}

@end
