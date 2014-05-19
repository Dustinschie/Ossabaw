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
{
    BOOL changed;
}
@property (strong, nonatomic) NSString *cellReuseName;
@property (strong, nonatomic) NSString *key;
@end

@implementation TableViewController
@synthesize places, cellReuseName, key, segControl, index, addButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark- viewControllerDelegate
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
//----------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    key = @"title";
    changed = true;
    [super viewDidLoad];
    //  set the reuse name for the tableCells
    cellReuseName = @"MyIdentifier";
    
    //  register a nib for the above reusename
    [[self tableView] registerNib:[UINib nibWithNibName:@"TableCell"
                                                 bundle:[NSBundle mainBundle]]
           forCellReuseIdentifier: cellReuseName];
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"Places" ofType:@"plist"];
    places = [NSDictionary dictionaryWithContentsOfFile:filePath][@"places"];
    
    //  set the tableView delegate as the current View controller
    [[self tableView] setDelegate:self];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
    //  set background imageView with a dark blur
    UIImageView *bg = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"sky.png"] applyDarkEffect]];
    //  set content mode of tableView
    [[self tableView] setContentMode:UIViewContentModeScaleAspectFill];
    //  set tableView's layer to mask
    [[[self tableView] layer] setMasksToBounds:YES];
    //  set tableView background
    [[self tableView] setBackgroundView:bg];
    
    //  make sure that the fetchedResults controller is working
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
//----------------------------------------------------------------------------------------------
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
    
}
//----------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//----------------------------------------------------------------------------------------------
- (IBAction)sorterKeyChanged:(id)sender
{   //  set the sort key to either 'title' or 'data'
    switch ([[self segControl] selectedSegmentIndex]) {
        case 0:
            [self setKey:@"title"];
            
            break;
        case 1:
            [self setKey:@"date"];
            break;
        default:
            break;
    }
    changed = true;
    
    // now that the sort key has changed reload fetchedResults controller & maker sure it still works
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@, %@", error, [error userInfo], [error localizedDescription]);
		abort();
    }
    //  reload the tableView data
    [[self tableView] reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //  get the number of sections fromfetchedResultsController
    NSInteger count = [[[self fetchedResultsController] sections] count];
    // Return the number of sections.
    return count == 0 ? 1 : count;
}
//----------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if ([[[self fetchedResultsController] sections] count] > 0) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
        //  set number of rows
        numberOfRows = [sectionInfo numberOfObjects];
    }
    // Return the number of rows in the section.
    return numberOfRows;
}
//----------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // dequeue a TableViewCell, then set its recipe to the recipe for the current row
    TableCell *cell = (TableCell *)[atableView dequeueReusableCellWithIdentifier:cellReuseName forIndexPath:indexPath];
    
    return cell;
}
//----------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // return the height that I want for the cell (the height of the cell in the nib)
    return 70;
}

#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
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
//----------------------------------------------------------------------------------------------
//- (BOOL) tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}

//- (BOOL) tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

//----------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  get tableCell from indexPath
    TableCell *cell = (TableCell *)[aTableView cellForRowAtIndexPath:indexPath];
    //  perform segue with the cell's journal
    [self performSegueWithIdentifier:@"tableToInfo" sender:[cell journal]];
}
//----------------------------------------------------------------------------------------------
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath
{
    
}
//----------------------------------------------------------------------------------------------
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}
//----------------------------------------------------------------------------------------------
// Override to support lazy loading of cell
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:(TableCell *)cell atIndexPath:indexPath];
}
//----------------------------------------------------------------------------------------------
// Override to support lazy loading of cell
- (void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(TableCell *) cell setJournal:nil];
}
//----------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)atableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
}
//----------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)atableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
}
//----------------------------------------------------------------------------------------------
- (void) configureCell: (TableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Journal *journal = (Journal *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
//    NSLog([journal title]);
    [cell setJournal:journal];
}

#pragma mark - journal support
//----------------------------------------------------------------------------------------------
- (void) journalEntryMakerViewController:(JournalEntryMakerViewController *)journalEntryMakerViewController
                           didAddJournal:(Journal *)journal
{
    if (![[self presentedViewController] isBeingDismissed]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

#pragma mark - Navigation
//----------------------------------------------------------------------------------------------
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"tableToInfo"]) {
        JournalViewController *jvc = (JournalViewController *)segue.destinationViewController;
        [jvc setHidesBottomBarWhenPushed:YES];
        Journal *journal = nil;
        if ([sender isKindOfClass:[Journal class]]) {
            journal = (Journal *) sender;
        } else{
            // the sender is ourselves (user tapped an existing journal)
            NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
            journal = (Journal *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
        }
        [jvc setJournal:journal];
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
    }
}
//----------------------------------------------------------------------------------------------
- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString*)scope
{
    NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
}
#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
#pragma mark - Fectched Results Controller
//----------------------------------------------------------------------------------------------
- (NSFetchedResultsController *)fetchedResultsController{
    // Set up the fetched results controller if needed.
    if (changed) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Journal" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        [self setFetchedResultsController: aFetchedResultsController];
        changed = false;
    }
	return _fetchedResultsController;
}
//----------------------------------------------------------------------------------------------
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] beginUpdates];
}
//----------------------------------------------------------------------------------------------
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *atableView = [self tableView];
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[atableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[atableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:(TableCell *)[atableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[atableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            [atableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            break;
	}
}
//----------------------------------------------------------------------------------------------
- (void) controller:(NSFetchedResultsController *)controller
   didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
            atIndex:(NSUInteger)sectionIndex
      forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
		case NSFetchedResultsChangeInsert:
			[[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
			break;
	}

}
//----------------------------------------------------------------------------------------------
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //  The fetch controller has sent all current change notifications,
    //  so tell the table view to process all results
    [[self tableView] endUpdates];
}




@end
