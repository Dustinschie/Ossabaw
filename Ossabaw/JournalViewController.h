//
//  JournalViewController.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/8/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JournalEntryMakerViewController.h"
#import <BlurryModalSegue/BlurryModalSegue.h>
#import "ImageCollectionViewController.h"
@class Journal;
@class Photo;

@interface JournalViewController : UIViewController
<UIScrollViewDelegate, JournalAddDelegate,
UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet  UIButton        *button;
@property (strong, nonatomic) IBOutlet  UIPageControl   *pageControl;
@property (strong, nonatomic) IBOutlet  UIScrollView    *scrollView;
@property (strong, nonatomic) IBOutlet  UIBarButtonItem *editButton;

@property (strong, nonatomic) IBOutlet  UITextView      *textView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;


@property (strong, nonatomic)           NSMutableDictionary *place;
@property (strong, nonatomic)           Journal         *journal;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)editButtonPressed:(id)sender;
- (IBAction)enlargePhoto:(id)sender;
- (IBAction)doubleTappedCell:(id)sender;
- (UIImage *) cropImage: (UIImage *) image toRect: (CGRect) rect;
@end
