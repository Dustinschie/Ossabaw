//
//  TableViewController.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/11/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JournalViewController.h"

@interface TableViewController : UITableViewController<UITableViewDataSource, NSFetchedResultsControllerDelegate, JournalAddDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet  UITableView                     *tableView;
@property (strong, nonatomic)           NSMutableArray                  *places;
@property (strong, nonatomic) IBOutlet  UIBarButtonItem                 *addButton;

@property (strong, nonatomic)           NSManagedObjectContext          *managedObjectContext;
@property (strong, nonatomic)           NSFetchedResultsController      *fetchedResultsController;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

-(IBAction)AddButtonPressed:(id)sender;
@property NSInteger index;

@end
