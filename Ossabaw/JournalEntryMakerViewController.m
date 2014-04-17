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
@synthesize doneButton, pageControl, textView, titleTextField, imageScrollView, scrollView, images, index, toolBar, colorSwitch;

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
    
    //  setup the outer scroll view
    [[self scrollView] setAlwaysBounceVertical:YES];
    [[self scrollView] setScrollEnabled:YES];
    [[self scrollView] setPagingEnabled:NO];
    
    // setup the textview that contains notes
    [[[self textView] layer] setCornerRadius:5];
    [[self textView] setDelegate:self];
    // setup the done button
    [[[self doneButton] layer] setCornerRadius:5];

    [[self titleTextField] setDelegate:self];
    
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [[self scrollView] setContentSize:CGSizeMake([[self scrollView] frame].size.width, [[self scrollView] frame].size.height * 1.5)];
    [[[self scrollView] layer] setCornerRadius:5];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Take a Photo", @"Camera Roll", nil
                          ];
    [alert show];
    
    

}

-(IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    // Do some stuff
    
     [self dismissViewControllerAnimated:YES completion:nil];
}
//----------------------------------------------------------------------------------------------
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];

    if (chosenImage.size.width != 0 && chosenImage.size.height != 0) {
        
        [[self images] addObject:chosenImage];
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
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
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
//----------------------------------------------------------------------------------------------
- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [[self scrollView] setContentOffset:CGPointMake([[self scrollView] contentOffset].x,
                                                    [[self textView] frame].origin.y - 1.75*[[self textView] frame].size.height)
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