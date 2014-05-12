//
//  TableCell.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/27/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Journal.h"

@interface TableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet    UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet    UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet    UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet    UIImageView *thumbnailImageView;
@property (strong, nonatomic)   Journal *   journal;
@property (strong, nonatomic) IBOutlet UIView *line;

@end
