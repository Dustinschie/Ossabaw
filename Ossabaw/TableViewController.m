//
//  TableViewController.m
//  Ossabaw
//
//  Created by Dustin Schie on 4/11/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import "TableViewController.h"
#import "Journal.h"
#import "TableCell.h"
#import "UIImage+ImageEffects.h"


@interface TableViewController ()
@property (strong, nonatomic) NSString *cellReuseName;
@end

@implementation TableViewController
@synthesize places, cellReuseName;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellReuseName = @"MyIdentifier";
    [[self tableView] registerNib:[UINib nibWithNibName:@"TableCell"
                                                 bundle:[NSBundle mainBundle]]
           forCellReuseIdentifier: cellReuseName];
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"Places" ofType:@"plist"];
    places = [NSDictionary dictionaryWithContentsOfFile:filePath][@"places"];
    [[self tableView] setDelegate:self];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
    UIImageView *bg = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"sky.png"] applyExtraLightEffect]];
    [[self tableView] setContentMode:UIViewContentModeScaleAspectFill];

    [[[self tableView] layer] setMasksToBounds:YES];
    [[self tableView] setBackgroundView:bg];
//    [[[[self tableView] backgroundView] superview] setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.8]];
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@, %@", error, [error userInfo], [error localizedDescription]);
		abort();
    }
    
}

 - (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                 duration:(NSTimeInterval)duration
{
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        [[[self tableView] backgroundView] setTransform: CGAffineTransformMakeRotation(M_PI / 2)];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        [[[self tableView] backgroundView] setTransform: CGAffineTransformMakeRotation(-M_PI / 2)];
    }
    else {
        [[[self tableView] backgroundView] setTransform: CGAffineTransformMakeRotation(0.0)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//----------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[[self fetchedResultsController] sections] count];
    // Return the number of sections.
    return count == 0 ? 1 : count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if ([[[self fetchedResultsController] sections] count] > 0) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    // Return the number of rows in the section.
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // dequeue a TableViewCell, then set its recipe to the recipe for the current row
    TableCell *cell = (TableCell *)[tableView dequeueReusableCellWithIdentifier:cellReuseName forIndexPath:indexPath];
//    if (cell == nil) {
//        UIViewController *temp = [[UIViewController alloc] initWithNibName:@"TableCell" bundle:nil];
//        cell = (TableCell *)[temp view];
//    }


    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
}


#pragma mark - UITableViewDelegate

// Override to support editing the table view.
- (void)    tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSManagedObjectContext *context = [[self fetchedResultsController] managedObjectContext];
        [context deleteObject:[[self fetchedResultsController] objectAtIndexPath:indexPath]];
        
        // save the context
        NSError *error;
        if (![context save:&error]) {
            /*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
        }
    }
}
//- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self setIndex:[indexPath row]];
    TableCell *cell = (TableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    [self performSegueWithIdentifier:@"tableToInfo" sender:[cell journal]];
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath
{
    
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

// Override to support lazy loading of cell
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
        [self configureCell:(TableCell *)cell atIndexPath:indexPath];
}

- (void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ((TableCell *) cell).journal = nil;
}

- (void) configureCell: (TableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Journal *journal = (Journal *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    [cell setJournal:journal];
}


#pragma mark - journal support
//----------------------------------------------------------------------------------------------
- (void) journalEntryMakerViewController:(JournalEntryMakerViewController *)journalEntryMakerViewController didAddJournal:(Journal *)journal
{
    if (![[self presentedViewController] isBeingDismissed]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}
//----------------------------------------------------------------------------------------------


//-(IBAction)AddButtonPressed:(id)sender
//{
//    [self performSegueWithIdentifier:@"blurryModalSegue" sender:self];
//    
//}

#pragma mark - Navigation
//----------------------------------------------------------------------------------------------
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"tableToInfo"]) {
        JournalViewController *jvc = (JournalViewController *)segue.destinationViewController;
        Journal *journal = nil;
        if ([sender isKindOfClass:[Journal class]]) {
            journal = (Journal *) sender;
        } else{
            // the sender is ourselves (user tapped an existing journal)
            NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
            journal = (Journal *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
        }
        [jvc setJournal:journal];
        
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary: [places objectAtIndex:[self index]]];
//        [jvc setPlace: dict];
        
    }
    
    else if ([[segue identifier] isEqualToString:@"toInfo"]) {
        JournalViewController *jvc = (JournalViewController *)segue.destinationViewController;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary: [places objectAtIndex:[self index]]];
        [jvc setPlace: dict];
    }
    
    else if ([[segue identifier] isEqualToString:@"blurryModalSegue"]) {

        JournalEntryMakerViewController *jemvc = (JournalEntryMakerViewController *) segue.destinationViewController;
        Journal *newJournal = [NSEntityDescription insertNewObjectForEntityForName:@"Journal"
                                                            inManagedObjectContext:[self managedObjectContext]];
        [jemvc setDelegate:self];
        [jemvc setJournal:newJournal andIsNewJournal:YES];


        
        
        BlurryModalSegue *bms = (BlurryModalSegue *) segue;
        [bms setBackingImageSaturationDeltaFactor:@(0.45)];
//        [bms setBackingImageTintColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
    }
    

}
#pragma mark - Fectched Results Controller
//----------------------------------------------------------------------------------------------
- (NSFetchedResultsController *)fetchedResultsController{
    // Set up the fetched results controller if needed.
    if (_fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Journal" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        [self setFetchedResultsController: aFetchedResultsController];
    }
	
	return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = [self tableView];
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:(TableCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
	}

    
}

- (void) controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
		case NSFetchedResultsChangeInsert:
			[[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}

}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //  The fetch controller has sent all current change notifications,
    //  so tell the table view to process all results
    [[self tableView] endUpdates];
}




@end
