//
//  JournalViewController.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/8/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JournalEntryMakerViewController.h"

@interface JournalViewController : UIViewController

<UIImagePickerControllerDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *topScrollView;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSMutableDictionary *place;
@property (strong, nonatomic) IBOutlet UIScrollView *subScrollView;


- (IBAction)takePhoto:(id)sender;
- (IBAction)selectPhoto:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (UIImage *) cropImage: (UIImage *) image toRect: (CGRect) rect;
@end