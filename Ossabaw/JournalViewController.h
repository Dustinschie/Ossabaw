//
//  JournalViewController.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/8/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JournalViewController : UIViewController

<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSMutableDictionary *place;

-(IBAction)buttonPressed:(id)sender;
@end
