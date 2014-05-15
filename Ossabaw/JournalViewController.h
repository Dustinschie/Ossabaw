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
#import "ASOTwoStateButton.h"
#import "ASOBounceButtonViewDelegate.h"
#import "BounceButtonView.h"
#import <Social/Social.h>

@class Journal;
@class Photo;

@interface JournalViewController : UIViewController
<UIScrollViewDelegate, JournalAddDelegate, UICollectionViewDataSource,
UICollectionViewDelegate, ASOBounceButtonViewDelegate>
{
    UIButton        *button;
    UIPageControl   *pageControl;
    UIScrollView    *scrollView;
    UIBarButtonItem *editButton;
    
//    UITextView      *textView;
    UIImageView *backgroundImageView;
    
    NSMutableDictionary *place;
    Journal         *journal;
    UICollectionView *collectionView;
}
@property (strong, nonatomic) IBOutlet ASOTwoStateButton *menuButton;
@property (strong, nonatomic) IBOutlet  UIButton        *button;
@property (strong, nonatomic) IBOutlet  UIPageControl   *pageControl;
@property (strong, nonatomic) IBOutlet  UIBarButtonItem *editButton;
@property (retain, nonatomic) IBOutlet  UITextView      *textView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;


@property (strong, nonatomic)           NSMutableDictionary *place;
@property (strong, nonatomic)           Journal             *journal;
@property (strong, nonatomic)           BounceButtonView    *menuItemView;

- (IBAction)editButtonPressed:(id)sender;
- (IBAction)doubleTappedCell:(id)sender;
- (IBAction)menuButtonAction:(id)sender;
- (UIImage *) cropImage: (UIImage *) image toRect: (CGRect) rect;
@end
