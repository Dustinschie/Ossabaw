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
            scrollView, images,index, toolBar, colorSwitch, datePicker, isNewJournal;

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
    [self setImages:[[NSMutableArray alloc] init]];
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
    
    // setup the textview that contains notes
    [[[self textView] layer] setCornerRadius:5];
    [[self textView] setDelegate:self];
    
    // setup the done button
    [[[self doneButton] layer] setCornerRadius:5];

    [[self titleTextField] setDelegate:self];

    [[self mapButton] setAlpha:0.75];
    
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

//  this method forces the orientation to be portrait only
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[self mapButton] layer] setMasksToBounds:YES];
    [[[self mapButton] layer] setCornerRadius:5];
    if (![self isNewJournal]) {
        [[self titleTextField] setText:[[self journal] title]];
        [[self textView] setText:[[self journal] information]];
        [[self datePicker] setDate:[[self journal] date]];
        [self stockImageScrollView];
    }
    
    
    
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
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        DropPinMapViewController *dpmvc = (DropPinMapViewController *) segue.destinationViewController;
        [dpmvc setCoord:[[self journal] location]];
        [dpmvc setDelegate:self];
}



#pragma mark - ScrollViewDelegate
//----------------------------------------------------------------------------------------------
- (void) scrollViewDidScroll:(UIScrollView *)aScrollView
{

    CGFloat viewWidth = [aScrollView frame].size.width;
    int numViews = [[aScrollView subviews] count];
    double pageNumber = ([aScrollView contentOffset].x - viewWidth / numViews) / viewWidth + 1;
    if (pageNumber <= [[self pageControl] numberOfPages]) {
        int pgnum = floor(pageNumber);
        if (pgnum == [[self pageControl] numberOfPages]) {
            [aScrollView setContentSize:CGSizeMake(viewWidth * (numViews + 1), [aScrollView frame].size.height)];
        }
        [self setIndex:pgnum];
        [[self pageControl] setCurrentPage:pgnum];
    } else{
        [aScrollView setContentOffset:CGPointZero animated:NO];
        [aScrollView setContentSize:CGSizeMake(viewWidth * numViews, [aScrollView frame].size.height)];
    }
    
//    CGFloat viewWidth = [aScrollView frame].size.width;
//    int numViews = [[aScrollView subviews] count];
//    int pageNumber = floor(([aScrollView contentOffset].x - viewWidth / numViews) / viewWidth + 1);
//    
//    [[self pageControl] setCurrentPage:pageNumber];
//    
//    [self setIndex:pageNumber];
}
#pragma mark - AddPinDelegate
//----------------------------------------------------------------------------------------------
- (void) dropPinMapViewController:(DropPinMapViewController *)dropPinMapViewController
                   didAddLocation:(NSString *)location
{
    [[self journal] setLocation:location];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//----------------------------------------------------------------------------------------------
-(IBAction)takePhoto:(id)sender
{
    NSString *title = @"",
             *cancelTitle = @"Cancel",
             *camera = @"Camera",
            *cameraRoll = @"Photo Library";
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
    if ([[self images] count] != 0 && [[self journal] icon] == nil) {
        Photo *photo = [[self images] objectAtIndex:0];
        [[self journal] setIcon:[[photo image] valueForKey:@"image"]];
        
        UIImage *a = [[self journal] icon];
    }
    
    NSError *error = nil;
    if (![[[self journal] managedObjectContext] save:&error]) {
        /*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }
    [[self delegate] journalEntryMakerViewController:self didAddJournal:[self journal]];
}

-(IBAction)openMap:(id)sender
{
    [self performSegueWithIdentifier:@"openMap" sender:self];
}

- (IBAction)removePhoto:(id)sender
{
    NSLog(@"%d removes", [sender tag]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Options" message:@"What do want to do?"
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete Image", @"Set as Icon", nil];
    [alert show];
    
}
//----------------------------------------------------------------------------------------------
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];

    if (chosenImage.size.width != 0 && chosenImage.size.height != 0) {
        NSManagedObjectContext *context = [[self journal] managedObjectContext];
        Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                                     inManagedObjectContext:context];

        NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
        [photo setName: [info objectForKey: [url lastPathComponent]]];
        
        NSManagedObject *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image"
                                                               inManagedObjectContext:[photo managedObjectContext]];
        [photo setImage:image];
        // set the image for the managed object "image"
        [image setValue:chosenImage forKeyPath:@"image"];
        [[self journal] addPhotosObject:photo];
        [[self images] addObject:photo];
        
        NSInteger   width =[[self imageScrollView] frame].size.width,
        height = [[self imageScrollView] frame].size.height;
        
        UIImage * anImage = [[photo image] valueForKey:@"image"];
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        int count = [[self images] count];
        [aButton setFrame:CGRectMake(width * count, 0, width, height)];
        [aButton setImage:anImage forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(removePhoto:)
          forControlEvents:UIControlEventTouchDownRepeat];

        [aButton setTag:count];
        
        [[self imageScrollView] addSubview:aButton];
        [[self imageScrollView] setContentSize:CGSizeMake(width * (count + 1),height)];
        [[self pageControl] setNumberOfPages: count + 1];
        
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

    Photo *photo = [[self images] objectAtIndex:[self index] - 1];
    switch (buttonIndex) {
        case 2:
        {
            [[self journal] setIcon:[[photo image] valueForKey:@"image"]];
            break;
        }
        case 1:
        {
            BOOL isFirst = YES;
            for (UIView *subView in [[self imageScrollView] subviews]) {
                if (isFirst) {
                    isFirst = NO;
                    continue;
                }
                [subView removeFromSuperview];
            }
            [[self journal] removePhotosObject:photo];
            [[self images] removeAllObjects];
            NSManagedObjectContext *context = [photo managedObjectContext];
            [context deleteObject:photo];
            [self stockImageScrollView];
            break;
        }
        default:
            break;
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

#pragma mark - textViewDelegate
//----------------------------------------------------------------------------------------------
- (void) textViewDidBeginEditing:(UITextView *)textView
{
        [[self scrollView] setPagingEnabled:NO];
    [[self scrollView] setContentOffset:CGPointMake([[self scrollView] contentOffset].x,
                                                    [[self textView] frame].origin.y - 1.75*[[self textView] frame].size.height )
                               animated:YES];
    
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    [[self scrollView] setPagingEnabled:YES];
    
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([[textView text] isEqualToString:@"Enter some stuff!"]) {
        [textView setText:@""];
    }
    return YES;
}


//-(void) textViewDidChangeSelection:(UITextView *)atextView
//{
//        [[self scrollView] setContentOffset:CGPointMake([[self scrollView] contentOffset].x,
//                                                    [atextView frame].origin.y - 1.75*[atextView frame].size.height)
//                                   animated:YES];
//}


//----------------------------------------------------------------------------------------------
- (UIImage *) cropImage: (UIImage *) image toRect: (CGRect) rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

- (void) setJournal:(Journal *)journal andIsNewJournal: (BOOL) thisIsNewJournal{
    [self setIsNewJournal:thisIsNewJournal];
    [self setJournal:journal];
}

- (void) stockImageScrollView
{
    int i = 1,
    width = [[self imageScrollView] frame].size.width,
    height = [[self imageScrollView] frame].size.height;
    for (Photo *photo in [[self journal] photos]) {
        [[self images] addObject:photo];
        UIImage * image = [[photo image] valueForKey:@"image"];
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton setFrame:CGRectMake(width * i, 0, width, height)];
        //dfg;ojwrg nlaijg nlzifjg nozkfgj aleij lgnsk jgnlz jg
        [[aButton imageView] setContentMode:UIViewContentModeScaleAspectFill];
        //dfg;ojwrg nlaijg nlzifjg nozkfgj aleij lgnsk jgnlz jg
        [aButton setImage:image forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(removePhoto:)
          forControlEvents:UIControlEventTouchDownRepeat];
        [aButton setTag:i];
        i++;
        [[self imageScrollView] addSubview:aButton];
    }
    [[self imageScrollView] setContentSize:CGSizeMake(i * width, height)];
    [[self pageControl] setNumberOfPages:i];
}

@end
