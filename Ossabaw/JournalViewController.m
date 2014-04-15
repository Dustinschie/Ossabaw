//
//  JournalViewController.m
//  Ossabaw
//
//  Created by Dustin Schie on 4/8/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import "JournalViewController.h"

@interface JournalViewController ()

@end

@implementation JournalViewController

@synthesize pageControl, scrollView, textView, place, button, subScrollView;

-(void) viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"hello");
    

    [self setTitle: (NSString *)[place objectForKey:@"Name"]];
    // Edit scrollView with images
    [[self scrollView] setDelegate:self];
    NSInteger numberOfViews = [[place objectForKey:@"Images"] count];
    [[self scrollView] setContentSize:
                            CGSizeMake([[self scrollView] frame].size.width * numberOfViews,
                                       [[self scrollView] frame].size.height)];
    [[self scrollView] setShowsHorizontalScrollIndicator:NO];
    [[self scrollView] setShowsVerticalScrollIndicator:NO];
    [[self scrollView] setPagingEnabled:YES];
    [[self scrollView] setAlwaysBounceVertical:NO];
    [[self scrollView] setAlwaysBounceHorizontal:YES];
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * [[self scrollView] frame].size.width;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(xOrigin, 0,
                                         [[self scrollView] frame].size.width,
                                         [[self scrollView] frame].size.height)];
        UIImage *image = [UIImage imageNamed:[[place objectForKey:@"Images"] objectAtIndex: i]];
        
        if ([image size].width > [image size].height) {
            CGRect cropRect = CGRectMake(([image size].width - [image size].height) / 2, 0,
                                         [image size].height, [image size].height);
            image = [self cropImage:image toRect:cropRect];
        }
        
        else if ([image size].width < [image size].height) {
            CGRect cropRect = CGRectMake(0, ([image size].height - [image size].width) / 2,
                                         [image size].width, [image size].width);
            image = [self cropImage:image toRect:cropRect];
        }
        
        [imageView setImage: image];
        [imageView setContentMode: UIViewContentModeScaleAspectFill];
        [[self scrollView] addSubview:imageView];
    }
    //set the scroll view content size
    [[self scrollView] setContentSize: CGSizeMake([[self scrollView] frame].size.width * numberOfViews,
                                                  [[self scrollView] frame].size.height)];
    
    //set the number of dots in pageControl
    [[self pageControl] setNumberOfPages:numberOfViews];
    [[self pageControl] setUserInteractionEnabled:NO];
    
    
    
    [[self subScrollView] setContentSize:CGSizeMake([[self subScrollView] frame].size.width * 1.25,
                                                    [[self subScrollView] frame].size.height)];
    [[self subScrollView] setAlwaysBounceVertical:NO];
    [[self subScrollView] setAlwaysBounceHorizontal:NO];
    [[self subScrollView] setPagingEnabled:YES];
    
    //  set Text View
    [self setTextView: [[UITextView alloc] init]];
    [[self textView] setFrame:CGRectMake(0, 0, [[self subScrollView] frame].size.width,
                                         [[self subScrollView] frame].size.height)];
    
    [[self textView] setText:(NSString *)[place objectForKey:@"Information"]];
    [[self textView] setEditable:NO];
    
    [[self subScrollView] addSubview:[self textView]];
    
    [self setButton: [[UIButton alloc] init]];
    [[self button] setFrame:CGRectMake([[self subScrollView] frame].size.width, 0,
                                       [[self subScrollView] frame].size.width * 0.25,
                                       [[self subScrollView] frame].size.height)];

//    [[self button] setTitle:@"+" forState:UIControlStateNormal];
    UIImage *buttonImage = [UIImage imageNamed:@"UIBarButtonCamera_2x.png"];
    [[self button] setImage:buttonImage forState:UIControlStateNormal];
    
    [[self subScrollView] addSubview: [self button]];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Device has no Camera"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [[self button] addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [[self button] addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }

    
    

   }


- (void) viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

//-(void) scrollViewDidScroll:(UIScrollView *)scrollView
//{
////    CGFloat
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//----------------------------------------------------------------------------------------------

- (IBAction)takePhoto:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [picker setAllowsEditing:YES];
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)selectPhoto:(id)sender
{
    //    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    [picker setDelegate:self];
    //    [picker setAllowsEditing:YES];
    //    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    //
    //    [self presentViewController:picker animated:YES completion:nil];
    JournalEntryMakerViewController *je = [[JournalEntryMakerViewController alloc] init];
    [self presentViewController:je animated:YES completion:nil];
}

//----------------------------------------------------------------------------------------------
// Crop image to specifications in rect
- (UIImage *) cropImage: (UIImage *) image toRect: (CGRect) rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

//----------------------------------------------------------------------------------------------
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSInteger   width =[[self scrollView] frame].size.width,
                height = [[self scrollView] frame].size.height,
                views = [[[self scrollView] subviews] count];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(width * views, 0, width, height)];
    [imageView setContentMode: UIViewContentModeScaleAspectFill];
    [imageView setImage:chosenImage];
    [[self scrollView] addSubview:imageView];
    [[self scrollView] setContentSize:CGSizeMake(width * (views + 1),height)];
    [[self pageControl] setNumberOfPages: views + 1];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//----------------------------------------------------------------------------------------------

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat viewWidth = [scrollView frame].size.width;
    int numViews = [[scrollView subviews] count];
    int pageNumber = floor(([scrollView contentOffset].x - viewWidth / numViews) / viewWidth + 1);
    [[self pageControl] setCurrentPage:pageNumber];
}

@end
