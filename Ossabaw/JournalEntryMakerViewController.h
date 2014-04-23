//
//  JournalEntryMakerViewController.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/14/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Journal;



@interface JournalEntryMakerViewController : UIViewController <UIScrollViewDelegate,
                                                    UIImagePickerControllerDelegate,
                                                                UITextFieldDelegate,
                                                                 UITextViewDelegate,
                                                              UIActionSheetDelegate,
                                                                UIAlertViewDelegate,
                                                             UIPickerViewDataSource,
                                                                UIPickerViewDelegate,
                                                  NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView     *scrollView;
@property (strong, nonatomic) IBOutlet UIScrollView     *imageScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl    *pageControl;
@property (strong, nonatomic) IBOutlet UITextView       *textView;
@property (strong, nonatomic) IBOutlet UIButton         *doneButton;
@property (strong, nonatomic) IBOutlet UITextField      *titleTextField;
@property (strong, nonatomic) IBOutlet UIToolbar        *toolBar;
@property (strong, nonatomic) IBOutlet UISwitch         *colorSwitch;
@property (strong, nonatomic) IBOutlet UIPickerView     *locationPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker     *datePicker;

@property (strong, nonatomic)           NSMutableArray  *images;
@property                               NSInteger        index;
@property (strong, nonatomic)           NSArray         *locations;

@property (strong, nonatomic)           NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic)           NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic)           Journal         *journal;

- (IBAction)takePhoto:(id)sender;
- (IBAction)dismiss:(id)sender;
- (IBAction)switchChanged:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

- (UIImage *) cropImage: (UIImage *) image toRect: (CGRect) rect;

@end
