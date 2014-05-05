//
//  JournalEntryMakerViewController.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/14/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Journal.h"
#import "Photo.h"
#import "BlurryModalSegue/BlurryModalSegue.h"
#import "DropPinMapViewController.h"
@protocol JournalAddDelegate;

@interface JournalEntryMakerViewController : UIViewController <UIScrollViewDelegate,
                                                    UIImagePickerControllerDelegate,
                                                                UITextFieldDelegate,
                                                                 UITextViewDelegate,
                                                              UIActionSheetDelegate,
                                                                UIAlertViewDelegate,
                                                    NSFetchedResultsControllerDelegate,
                                                    AddPinDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView     *scrollView;
@property (strong, nonatomic) IBOutlet UIScrollView     *imageScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl    *pageControl;
@property (strong, nonatomic) IBOutlet UITextView       *textView;
@property (strong, nonatomic) IBOutlet UIButton         *doneButton;
@property (strong, nonatomic) IBOutlet UITextField      *titleTextField;
@property (strong, nonatomic) IBOutlet UIToolbar        *toolBar;
@property (strong, nonatomic) IBOutlet UISwitch         *colorSwitch;
@property (strong, nonatomic) IBOutlet UIDatePicker     *datePicker;

@property (strong, nonatomic)           NSMutableArray  *images;
@property (strong, nonatomic)           NSMutableArray  *imageIndexes;
@property                               NSInteger        index;

@property (strong, nonatomic)           NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic)           NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic)           Journal         *journal;
@property (unsafe_unretained, nonatomic) id <JournalAddDelegate> delegate;
@property                               BOOL            isNewJournal;
@property (strong, nonatomic) IBOutlet UIButton *mapButton;

- (IBAction)takePhoto:(id)sender;
- (IBAction)dismiss:(id)sender;
- (IBAction)switchChanged:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)openMap:(id)sender;
- (IBAction)removePhoto:(id)sender;

- (UIImage *) cropImage: (UIImage *) image
                 toRect: (CGRect) rect;

- (void) setJournal:(Journal *)journal andIsNewJournal: (BOOL) isNewJournal;
- (void) stockImageScrollView;

@end

#pragma mark -

@protocol JournalAddDelegate <NSObject>

// journal == nil on cancel
- (void)journalEntryMakerViewController:(JournalEntryMakerViewController *)journalEntryMakerViewController
                          didAddJournal:(Journal *)journal;


@end
