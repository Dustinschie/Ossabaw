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
@synthesize cancelButton, doneButton, pageControl, textView, titleTextField, imageScrollView, scrollView, images, index;

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
    
    [[self cancelButton] addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
//    UIImageView *imageView = [[UIImageView alloc] init];
//    [imageView setFrame:CGRectMake(imgSVWidth, 0, imgSVWidth, imgSVheight)];
//    [imageView setContentMode:UIViewContentModeScaleAspectFit];
//    [imageView setImage: [UIImage imageNamed:@"clubhouse.png" ]];
//    [[self imageScrollView] addSubview:imageView];
    [[self imageScrollView] setContentSize:CGSizeMake(imgSVWidth, imgSVheight)];
    index = 1;
    
    //  setup pageControl
    [[self pageControl] setNumberOfPages: index];
    [[self pageControl] setCurrentPage:0];
    [[self pageControl] setEnabled:NO];
//    [self setTitleTextField: [[UITextField alloc] init]];
//    [[self titleTextField] setFrame:CGRectMake(0,
//                                               [[self pageControl] frame].origin.y + [[self pageControl] frame].size.height,
//                                               [[self imageScrollView] frame].size.width,
//                                               [[self imageScrollView] frame].size.height / 10)];
    [[[self titleTextField] layer] setCornerRadius: 5];
    [[[self titleTextField] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[[self titleTextField] layer] setBorderWidth: 1.5f];
//    [[self titleTextField] setText:@"hello"];
//    [[self scrollView] addSubview:[self titleTextField]];
    NSLog(@"%f", [[self scrollView] frame].size.height);
    [[self scrollView] setDelegate:self];

    [[self scrollView] setAlwaysBounceVertical:YES];
    [[self scrollView] setScrollEnabled:YES];
    [[self scrollView] setPagingEnabled:NO];
    NSLog(@"%f", [[self scrollView] frame].size.height);
    [self setTextView:[[UITextView alloc] init]];
    [[self textView] setFrame: CGRectMake([[self titleTextField] frame].origin.x,
                                          [[self titleTextField] frame].origin.y
                                          + [[self titleTextField] frame].size.height * 2,
                                          [[self titleTextField] frame].size.width,
                                          [[self scrollView] frame].size.width / 2)];
    [[[self textView] layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[[self textView] layer] setCornerRadius:5];
    [[[self textView] layer] setBorderWidth:1.5f];
    [[self scrollView] addSubview:textView];
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [[self scrollView] setContentSize:CGSizeMake([[self scrollView] frame].size.width, [[self scrollView] frame].size.height * 1.5)];
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
//----------------------------------------------------------------------------------------------
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
//            NSLog(@"%f, %f", chosenImage.size.width, chosenImage.size.height);
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
        //    [[self pageControl] setCurrentPage:views + 1];
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