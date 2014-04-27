//
//  TableViewCell.m
//  Ossabaw
//
//  Created by Dustin Schie on 4/2/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import "TableViewCell.h"

@interface TableViewCell()
@property (strong, nonatomic) UIImageView *journalImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *overviewLabel;
@property (strong, nonatomic) UILabel *dateLabel;

- (CGRect)_imageViewFrame;
- (CGRect)_nameLabelFrame;
- (CGRect)_descriptionLabelFrame;
- (CGRect)_dateLabelFrame;

@end
#define IMAGE_SIZE          42.0
#define EDITING_INSET       10.0
#define TEXT_LEFT_MARGIN    8.0
#define TEXT_RIGHT_MARGIN   5.0
#define PREP_TIME_WIDTH     80.0
@implementation TableViewCell

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _journalImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [[self journalImageView] setContentMode:UIViewContentModeScaleAspectFit];
        [[self contentView] addSubview:[self journalImageView]];
        
        _overviewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.overviewLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.overviewLabel setTextColor:[UIColor darkGrayColor]];
        [self.overviewLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.overviewLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        [self.dateLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.dateLabel setTextColor:[UIColor blackColor]];
        [self.dateLabel setHighlightedTextColor:[UIColor whiteColor]];
		self.dateLabel.minimumScaleFactor = 7.0;
		self.dateLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.dateLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.nameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [self.nameLabel setTextColor:[UIColor blackColor]];
        [self.nameLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [[self journalImageView] setFrame:[self _imageViewFrame]];
    [self.nameLabel setFrame:[self _nameLabelFrame]];
    [self.overviewLabel setFrame:[self _descriptionLabelFrame]];
    [self.dateLabel setFrame:[self _dateLabelFrame]];
    if (self.editing)
        self.dateLabel.alpha = 0.0;
    else
        self.dateLabel.alpha = 1.0;
    
}

// returns the frame of the various subviews -- these are dependent on the editing state of the cell
- (CGRect)_imageViewFrame {
    
    if (self.editing) {
        return CGRectMake(EDITING_INSET, 0.0, IMAGE_SIZE, IMAGE_SIZE);
    }
	else {
        return CGRectMake(0.0, 0.0, IMAGE_SIZE, IMAGE_SIZE);
    }
}

- (CGRect)_nameLabelFrame {
    
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_RIGHT_MARGIN * 2 - PREP_TIME_WIDTH, 16.0);
    }
}

- (CGRect)_descriptionLabelFrame {
    
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_LEFT_MARGIN, 16.0);
    }
}

- (CGRect)_dateLabelFrame {
    
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(contentViewBounds.size.width - PREP_TIME_WIDTH - TEXT_RIGHT_MARGIN, 4.0, PREP_TIME_WIDTH, 16.0);
}

#pragma mark - Journal set accessor

- (void)setJournal:(Journal *)newJournal {
    
    if (newJournal != _journal) {
        _journal = newJournal;
	}
	self.journalImageView.image = _journal.icon;
	self.nameLabel.text = (_journal.title.length > 0) ? _journal.title : @"-";
	self.overviewLabel.text = (_journal.information != nil) ? _journal.information : @"-";
    NSString *s = (_journal.date != nil) ? [NSDateFormatter localizedStringFromDate:_journal.date dateStyle:NSDateFormatterShortStyle timeStyle:nil] : @"-";
    NSLog(s);
	self.dateLabel.text = (_journal.date != nil) ? [NSDateFormatter localizedStringFromDate:_journal.date dateStyle:NSDateFormatterShortStyle timeStyle:nil] : @"-";
}




@end
