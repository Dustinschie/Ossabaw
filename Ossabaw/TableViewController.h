//
//  TableViewController.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/11/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JournalViewController.h"

@interface TableViewController : UITableViewController<UITableViewDataSource, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *places;
@property NSInteger index;


@end
