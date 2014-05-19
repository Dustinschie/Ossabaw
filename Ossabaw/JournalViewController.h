//
//  JournalViewController.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/8/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "BounceButtonView.h"
#import "ASOTwoStateButton.h"
#import "UIImage+ImageEffects.h"
#import "ASOBounceButtonViewDelegate.h"
#import <BlurryModalSegue/BlurryModalSegue.h>

#import "ImageCollectionViewController.h"
#import "JournalEntryMakerViewController.h"


@class Journal;
@class Photo;

@interface JournalViewController : UIViewController
<   UIScrollViewDelegate,
    JournalAddDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    ASOBounceButtonViewDelegate,
    MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet  ASOTwoStateButton   *menuButton;
@property (strong, nonatomic) IBOutlet  UIPageControl       *pageControl;
@property (strong, nonatomic) IBOutlet  UIBarButtonItem     *editButton;
@property (retain, nonatomic) IBOutlet  UITextView          *textView;
@property (strong, nonatomic) IBOutlet  UIImageView         *backgroundImageView;
@property (strong, nonatomic) IBOutlet  UICollectionView    *collectionView;

@property (strong, nonatomic)           NSMutableDictionary *place;
@property (strong, nonatomic)           Journal             *journal;
@property (strong, nonatomic)           BounceButtonView    *menuItemView;

- (IBAction)editButtonPressed:(id)sender;
- (IBAction)menuButtonAction:(id)sender;
- (void) displayEmailComposerSheet;
- (void) displaySMSComposerSheet;
@end
