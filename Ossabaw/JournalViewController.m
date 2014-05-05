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

@synthesize pageControl, scrollView, textView, place, button, subScrollView, editButton, journal;

-(void) viewDidLoad
{
    [super viewDidLoad];
    [scrollView setDelegate:self];
    
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    if ([self journal] != nil) {
        [self setTitle:[[self journal] title]];
        [[self textView] setText:[[self journal] information]];
        int num_of_photos = [[[self journal] photos] count],
        width =[[self scrollView] frame].size.width,
        height = [[self scrollView] frame].size.height;
        
        [[self pageControl] setNumberOfPages:num_of_photos];
        [[self scrollView] setContentSize:CGSizeMake(width* num_of_photos, height)];
        
        int i = 0;
        for (Photo* photo in [[self journal] photos]) {
            UIImage * image = [[photo image] valueForKey:@"image"];
            UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [aButton setFrame:CGRectMake(width * i, 0, width, height)];
            [aButton setContentMode:UIViewContentModeScaleAspectFill];
            [aButton setImage:image forState:UIControlStateNormal];
            [aButton addTarget:self action:@selector(enlargePhoto:) forControlEvents:UIControlEventTouchDownRepeat];
            
            i++;
            [[self scrollView] addSubview:aButton];
        }
    }
    else if([self place] != nil){
        [[self editButton] setEnabled:NO];
        [self setTitle:[place objectForKey:@"Name"]];
        [[self textView] setText:[place objectForKey:@"Information"]];
        NSArray *images = [[self place] objectForKey:@"Images"];
        int num_of_photos = [images count],
                    width =[[self scrollView] frame].size.width,
                    height = [[self scrollView] frame].size.height;
        NSLog(@"%d", num_of_photos);
        
        [[self pageControl] setNumberOfPages:num_of_photos];
        [[self scrollView] setContentSize:CGSizeMake(width* num_of_photos, height)];
        
        int i = 0;
        for (NSString *imageName in images) {
            UIImage *image = [UIImage imageNamed:imageName];
            UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [[aButton imageView] setFrame:CGRectMake(0, 0, width, height)];
            [[aButton imageView] setContentMode:UIViewContentModeScaleAspectFill];

            [aButton setFrame:CGRectMake(width * i, 0, width, height)];
            
            
            [aButton setImage:image forState:UIControlStateNormal];
            [aButton addTarget:self action:@selector(enlargePhoto:) forControlEvents:UIControlEventTouchDownRepeat];
            
            i++;
            [[self scrollView] addSubview:aButton];
        }

        
    }

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   }

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"gone");
    for (UIView *view in [[self scrollView] subviews]) {
        [view removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[BlurryModalSegue class]])
    {
        JournalEntryMakerViewController *jemvc = (JournalEntryMakerViewController *) segue.destinationViewController;
        [jemvc setDelegate:self];
        [jemvc setJournal:[self journal] andIsNewJournal:NO];

        BlurryModalSegue* bms = (BlurryModalSegue*)segue;
        [bms setBackingImageSaturationDeltaFactor:@(0.45)];
//        [bms setBackingImageTintColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
    }
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
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [picker setAllowsEditing:YES];
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)editButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"blurToEdit" sender:self];
}

-(IBAction)enlargePhoto:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enlarge Photo Button Pressed"
                                                    message:@"Needs implementation"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
        [alert show];
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
        [[self pageControl] setCurrentPage:pgnum];
    } else{
        [aScrollView setContentOffset:CGPointZero animated:NO];
        [aScrollView setContentSize:CGSizeMake(viewWidth * numViews, [aScrollView frame].size.height)];
    }

    
    
}

- (void) journalEntryMakerViewController:(JournalEntryMakerViewController *)journalEntryMakerViewController didAddJournal:(Journal *)aJournal
{
    if (journal != nil)
        [self setJournal:aJournal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
