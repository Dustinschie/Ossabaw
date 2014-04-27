//
//  TableViewCell.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/2/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Journal.h"
@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) Journal *journal;

@end
