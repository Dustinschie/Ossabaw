//
//  JournalEntryMakerViewController.m
//  Ossabaw
//
//  Created by Dustin Schie on 4/14/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import "JournalEntryMakerViewController.h"

@interface JournalEntryMakerViewController ()

@end

@implementation JournalEntryMakerViewController
@synthesize doneButton, pageControl, textView, titleTextField, imageScrollView,
            scrollView, images,index, toolBar, colorSwitch, locationPicker, datePicker,
            locations, imageIndexes, isNewJournal;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self toolBar] setClipsToBounds:YES];
    [self setLocations:[[NSArray alloc] initWithObjects:@"Blue",@"Green",@"Orange",@"Purple",@"Red",@"Yellow" , nil]];

    int imgSVWidth = [[self imageScrollView] frame].size.width;
    int imgSVheight = [[self imageScrollView] frame].size.height;
    
    //  add Button to image ScrollView
    UIButton *imageButton = [[UIButton alloc] init];
    [imageButton setFrame:CGRectMake(0, 0, imgSVWidth, imgSVheight)];
    UIImage *image = [UIImage imageNamed:@"UIBarButtonCamera_2x.png"];
    [imageButton setImage:image forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [[self imageScrollView] addSubview: imageButton];
    
    
    //  setup the the scroll view that holds the images
    [[self imageScrollView] setAlwaysBounceVertical:NO];
    [[self imageScrollView] setAlwaysBounceHorizontal:YES];
    [[self imageScrollView] setPagingEnabled:YES];
    [[self imageScrollView] setBounces:YES];
    [[[self imageScrollView] layer] setCornerRadius:5];
    [[self imageScrollView] setDelegate:self];
    [[self imageScrollView] setContentSize:CGSizeMake(imgSVWidth, imgSVheight)];
    
    [self setIndex:1];
    
    //  setup pageControl
    [[self pageControl] setNumberOfPages: index];
    [[self pageControl] setCurrentPage:0];
    [[self pageControl] setEnabled:NO];
    
    //  setup the title
    [[[self titleTextField] layer] setCornerRadius: 5];
    
    [[self titleTextField] setAttributedPlaceholder:[[NSAttributedString alloc]
                                                     initWithString:@"Title"
                                                     attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}]];
     
     
    
    //  setup the outer scroll view
    [[self scrollView] setAlwaysBounceVertical:YES];
//    [[self scrollView] setScrollEnabled:YES];
//    [[self scrollView] setPagingEnabled:NO];
    
    // setup the textview that contains notes
    [[[self textView] layer] setCornerRadius:5];
    [[self textView] setDelegate:self];
    // setup the done button
    [[[self doneButton] layer] setCornerRadius:5];

    [[self titleTextField] setDelegate:self];
    
    
    [[self locationPicker] setDelegate:self];
    [[self locationPicker] setDataSource:self];
    [[[self locationPicker] layer] setCornerRadius:5];
    
//    NSError *error = nil;
//    if (! [[self fetchedResultsController] performFetch:&error]) {
//        /*
//		 Replace this implementation with code to handle the error appropriately.
//		 
//		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//		 */
//		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//		abort();
//    }
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSInteger h = [[self scrollView] frame].size.height * 2;
    [[self scrollView] setContentSize:CGSizeMake([[self scrollView] frame].size.width, h)];
//    [[self scrollView] setPagingEnabled:YES];
    
//    [[[self scrollView] layer] setCornerRadius:5];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"Problems!");
}
//----------------------------------------------------------------------------------------------
- (void) scrollViewDidScroll:(UIScrollView *)aScrollView
{
    CGFloat viewWidth = [aScrollView frame].size.width;
    int numViews = [[aScrollView subviews] count];
    int pageNumber = floor(([aScrollView contentOffset].x - viewWidth / numViews) / viewWidth + 1);
    [[self pageControl] setCurrentPage:pageNumber];
}
//----------------------------------------------------------------------------------------------
-(IBAction)takePhoto:(id)sender
{
    NSString *title = @"",
             *cancelTitle = @"Cancel",
             *camera = @"Take a photo",
            *cameraRoll = @"Camera Roll";
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: title
                                                             delegate:self
                                                  cancelButtonTitle:cancelTitle
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:camera,cameraRoll, nil
                                  ];
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    

}

-(IBAction)dismiss:(id)sender
{
    if ([self isNewJournal]) {
        [[[self journal] managedObjectContext] deleteObject:[self journal]];
        NSError *error = nil;
        if (![[[self journal] managedObjectContext] save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        [[self delegate] journalEntryMakerViewController:self didAddJournal:nil];
    }
    [[self delegate] journalEntryMakerViewController:self didAddJournal:[self journal]];
}

- (IBAction)switchChanged:(id)sender
{
    if ([[self colorSwitch] isOn]) {
        [[self textView] setBackgroundColor:[UIColor blackColor]];
        [[self titleTextField] setBackgroundColor:[UIColor blackColor]];
    }
    else {
        [[self textView] setBackgroundColor:[[UIColor alloc] initWithRed:0 green:0.478431 blue:1 alpha:0.22]];
        [[self titleTextField] setBackgroundColor:[[UIColor alloc] initWithRed:0 green:0.478431 blue:1 alpha:0.22]];
    }
    
    
}

- (IBAction)doneButtonPressed:(id)sender
{
    [[self journal] setTitle: [[self titleTextField] text]];
    [[self journal] setDate: [[self datePicker] date]];
    [[self journal] setInformation:[[self textView] text]];
    
    if ([[self images] count] != 0) {
        UIImage *image = [[self images] objectAtIndex:0];
        CGSize size = image.size;
        CGFloat ratio = 0;
        if (size.width > size.height) {
            ratio = 44.0 / size.width;
        } else {
            ratio = 44.0 / size.height;
        }
        CGRect rect = CGRectMake(0, 0, ratio * size.width, ratio * size.height);
        [image drawInRect:rect];
        [[self journal] setIcon: UIGraphicsGetImageFromCurrentImageContext()];
        UIGraphicsEndImageContext();
//        
//        for (NSNumber *num  in [self imageIndexes]) {
//            NSManagedObjectContext *context = [[self journal] managedObjectContext];
//            Photo * photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
//            [[self journal] addPhotosObject:photo];
//            
//        }
    }
    
    
    [[self delegate] journalEntryMakerViewController:self didAddJournal:[self journal]];
}
//----------------------------------------------------------------------------------------------gith
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];

    if (chosenImage.size.width != 0 && chosenImage.size.height != 0) {
        NSManagedObjectContext *context = [[self journal] managedObjectContext];
        Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
        [photo setName: [info objectForKey: [url lastPathComponent]]];
        NSManagedObject *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image"
                                                               inManagedObjectContext:[photo managedObjectContext]];
        [photo setImage:image];
        // set the image for the image managed object
        [image setValue:chosenImage forKeyPath:@"image"];
        [[self journal] addPhotosObject:photo];
        
        
        
        [[self images] addObject:chosenImage];
        [[self imageIndexes] addObject:[NSNumber numberWithInt:[[self images] count] - 1]];
        NSInteger   width =[[self imageScrollView] frame].size.width,
        height = [[self imageScrollView] frame].size.height;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(width * index, 0, width, height)];
        [imageView setContentMode: UIViewContentModeScaleAspectFit];
        [imageView setImage:chosenImage];
        [[self imageScrollView] addSubview:imageView];
        index++;
        [[self imageScrollView] setContentSize:CGSizeMake(width * index,height)];
        [[self pageControl] setNumberOfPages: index];
        
    }
        [picker dismissViewControllerAnimated:YES completion:nil];

    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//----------------------------------------------------------------------------------------------
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

//----------------------------------------------------------------------------------------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Take a Photo"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setAllowsEditing:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if ([title isEqualToString:@"Camera Roll"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setAllowsEditing:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setAllowsEditing:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:picker animated:YES completion:nil];
    } else if(buttonIndex == 1){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setAllowsEditing:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        [self presentViewController:picker animated:YES completion:nil];
    }

}

#pragma mark - UIPickerViewDelegate
//----------------------------------------------------------------------------------------------
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return 6;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [[self locations] objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    
}
//----------------------------------------------------------------------------------------------
- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [[self scrollView] setContentOffset:CGPointMake([[self scrollView] contentOffset].x,
                                                    [[self textView] frame].origin.y - 1.75*[[self textView] frame].size.height )
                               animated:YES];
}
//----------------------------------------------------------------------------------------------
- (UIImage *) cropImage: (UIImage *) image toRect: (CGRect) rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

@end
