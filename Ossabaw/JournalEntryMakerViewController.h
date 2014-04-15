//
//  JournalEntryMakerViewController.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/14/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JournalEntryMakerViewController : UIViewController <UIScrollViewDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic)  UITextView *textView;
@property (strong, nonatomic)  UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) NSMutableArray *images;
@property NSInteger index;

-(IBAction)takePhoto:(id)sender;
-(IBAction)dismiss:(id)sender;

- (UIImage *) cropImage: (UIImage *) image toRect: (CGRect) rect;

@end
