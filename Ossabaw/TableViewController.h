//
//  TableViewController.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/11/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JournalViewController.h"
#import "AppDelegate.h"

@interface TableViewController : UITableViewController
<UITableViewDataSource, NSFetchedResultsControllerDelegate, JournalAddDelegate>
{
    UITableView                     *tableView;
    NSMutableArray                  *places;
    UIBarButtonItem                 *addButton;
    
    NSManagedObjectContext          *managedObjectContext;
    NSFetchedResultsController      *fetchedResultsController;
    UIView                          *topView;
    UISegmentedControl              *segControl;
    NSInteger                       index;
}

@property (strong, nonatomic) IBOutlet  UITableView                     *tableView;
@property (strong, nonatomic)           NSMutableArray                  *places;
@property (strong, nonatomic) IBOutlet  UIBarButtonItem                 *addButton;

@property (strong, nonatomic)           NSManagedObjectContext          *managedObjectContext;
@property (strong, nonatomic)           NSFetchedResultsController      *fetchedResultsController;
@property (strong, nonatomic) IBOutlet  UIView                          *topView;
@property (strong, nonatomic) IBOutlet  UISegmentedControl              *segControl;
@property                               NSInteger                       index;

- (IBAction)sorterKeyChanged:(id)sender;


@end
