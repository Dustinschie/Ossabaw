//
//  TableCell.m
//  Ossabaw
//
//  Created by Dustin Schie on 4/27/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell
@synthesize titleLabel = _titleLabel;
@synthesize subtitleLabel = _subtitleLabel;
@synthesize dateLabel = _dateLabel;
@synthesize thumbnailImageView = _thumbnailImageView;

- (void)awakeFromNib
{
//    [[self layer] setMasksToBounds:YES];
//    [[self layer] setCornerRadius:[[self thumbnailImageView] frame].size.height / 2];
    [[[self thumbnailImageView] layer] setMasksToBounds:YES];
    [[[self thumbnailImageView] layer] setCornerRadius: [[[self thumbnailImageView] layer] frame].size.width / 2];
    [[[self thumbnailImageView] layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    [[[self thumbnailImageView] layer] setBorderWidth:2.0];
    //  set color of both background and contentView to clear
    [self setBackgroundColor:[UIColor clearColor]];
    [[self contentView] setBackgroundColor:[UIColor clearColor]];
    [[[self line] layer] setCornerRadius:1];
    [[self layer] setMasksToBounds:YES];

    [[self layer] setCornerRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setJournal:(Journal *)newJournal
{
    if (newJournal != _journal) {
        _journal = newJournal;
	}
    [[self thumbnailImageView] setContentMode:UIViewContentModeScaleAspectFill];
    [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [[self thumbnailImageView] setImage: [_journal icon]];

	self.titleLabel.text = (_journal.title.length > 0) ? _journal.title : @"-";
	self.subtitleLabel.text = (_journal.information != nil) ? _journal.information : @"-";
	self.dateLabel.text = (_journal.date != nil) ? [NSDateFormatter localizedStringFromDate:_journal.date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle] : @"-";
}

@end
