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
@synthesize doneButton, pageControl, textView, titleTextField, imageScrollView, scrollView, images, index, navigationItem, toolBar, colorSwitch;

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
    [[self imageScrollView] setDelegate:self];
    //  add Button to image ScrollView
    UIButton *imageButton = [[UIButton alloc] init];
    [imageButton setFrame:CGRectMake(0, 0, imgSVWidth, imgSVheight)];
    UIImage *image = [UIImage imageNamed:@"UIBarButtonCamera_2x.png"];
    [imageButton setImage:image forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [[self imageScrollView] addSubview: imageButton];
    [[self imageScrollView] setAlwaysBounceVertical:NO];
    [[self imageScrollView] setAlwaysBounceHorizontal:YES];
    [[self imageScrollView] setPagingEnabled:YES];
    [[self imageScrollView] setBounces:YES];
    
    [[self imageScrollView] setContentSize:CGSizeMake(imgSVWidth, imgSVheight)];
    index = 1;
    
    //  setup pageControl
    [[self pageControl] setNumberOfPages: index];
    [[self pageControl] setCurrentPage:0];
    [[self pageControl] setEnabled:NO];
    [[[self titleTextField] layer] setCornerRadius: 5];
    [[[self titleTextField] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[[self titleTextField] layer] setBorderWidth: 1.5f];
    [[self scrollView] setDelegate:self];

    [[self scrollView] setAlwaysBounceVertical:YES];
    [[self scrollView] setScrollEnabled:YES];
    [[self scrollView] setPagingEnabled:NO];
    [[[self textView] layer] setCornerRadius:5];
    [[[self imageScrollView] layer] setCornerRadius:5];
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [[self scrollView] setContentSize:CGSizeMake([[self scrollView] frame].size.width, [[self scrollView] frame].size.height * 1.5)];
    [[[self scrollView] layer] setCornerRadius:5];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 22)];
    [textField setText:@"Title"];
    [textField setFont: [UIFont boldSystemFontOfSize:19]];
    [textField setTextAlignment:NSTextAlignmentCenter];
    [[self navigationItem] setTitleView:textField];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [picker setAllowsEditing:YES];
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [self presentViewController:picker animated:YES completion:nil];
}

-(IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)switchChanged:(id)sender
{
    if ([[self colorSwitch] isOn]) {
        [[self textView] setTextColor:[UIColor whiteColor]];
        [[self textView] setBackgroundColor:[UIColor blackColor]];
    }
    else{
       [[self textView] setBackgroundColor:[[UIColor alloc] initWithRed:0 green:0.478431 blue:1 alpha:0.22]];
    }
    
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
        [imageView setContentMode: UIViewContentModeScaleAspectFill];
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
- (UIImage *) cropImage: (UIImage *) image toRect: (CGRect) rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

@end