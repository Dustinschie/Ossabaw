//
//  JournalViewController.m
//  Ossabaw
//
//  Created by Dustin Schie on 4/8/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import "JournalViewController.h"
#import "UIImage+ImageEffects.h"
#import <QuartzCore/QuartzCore.h>

@interface JournalViewController (){
}

@end

@implementation JournalViewController

@synthesize pageControl, textView, place, button, editButton, journal;

-(void) viewDidLoad
{
    [super viewDidLoad];
    UIImage *bgImage = [[ UIImage imageNamed:@"sky.png"]applyLightEffect];
    [[self backgroundImageView] setImage:bgImage];
    [[self view] sendSubviewToBack:[self backgroundImageView]];

}

- (void) viewWillAppear:(BOOL)animated
{
    [[self collectionView] reloadData];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [super viewDidAppear:animated];
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[[self tabBarController] tabBar] setHidden:YES];
    if ([self journal] != nil) {
        [self setTitle:[[self journal] title]];
        
        [[self textView] setText:[[self journal] information]];
        int num_of_photos = [[[self journal] photos] count];
        
        [[self pageControl] setNumberOfPages:num_of_photos];
    }
    else if([self place] != nil){
        [[self editButton] setEnabled:NO];
        [self setTitle:[place objectForKey:@"Name"]];
        [[self textView] setText:[place objectForKey:@"Information"]];
        NSArray *images = [[self place] objectForKey:@"Images"];
        int num_of_photos = [images count];
        
        [[self pageControl] setNumberOfPages:num_of_photos];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];

}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self setTitle:nil];
    [self setTextView:nil];
    [[self collectionView] reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"blurToEdit"])
    {
        JournalEntryMakerViewController *jemvc = (JournalEntryMakerViewController *) segue.destinationViewController;
        [jemvc setDelegate:self];
        [jemvc setJournal:[self journal] andIsNewJournal:NO];
        BlurryModalSegue* bms = (BlurryModalSegue*)segue;
        [bms setBackingImageSaturationDeltaFactor:@(0.45)];
    }else if ([[segue identifier] isEqualToString:@"blurToImage"]){
        ImageCollectionViewController* icvc = (ImageCollectionViewController *) segue.destinationViewController;
        [icvc setJournal:journal];
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image = [image applyLightEffect];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [[icvc collectionView] setBackgroundView:imageView];
        
//        [bms setBackingImageTintColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.1]];
        
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
- (IBAction)doubleTappedCell:(id)sender
{
    CGPoint tappedPoint = [sender locationInView:self.collectionView];
    NSIndexPath *tappedCellPath = [self.collectionView indexPathForItemAtPoint:tappedPoint];
    
    if (tappedCellPath)
    {
        UICollectionViewCell *cell = (UICollectionViewCell *)[self.collectionView cellForItemAtIndexPath:tappedCellPath];
        [self.collectionView selectItemAtIndexPath:tappedCellPath
                                          animated:YES
                                    scrollPosition:UICollectionViewScrollPositionNone];
        
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enlarge Photo Button Pressed"
                                                    message:@"Needs implementation"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}
#pragma mark - UIScrollViewDelegate
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
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSIndexPath *indexPath = [[[self collectionView] indexPathsForVisibleItems] objectAtIndex:0];
//    [[self collectionView] scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//}
#pragma mark - journal support
//----------------------------------------------------------------------------------------------

- (void) journalEntryMakerViewController:(JournalEntryMakerViewController *)journalEntryMakerViewController didAddJournal:(Journal *)journal
{
    [self setJournal:journal];
    if (![[self presentedViewController] isBeingDismissed]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[self journal] photos] count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"hell");
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCellID"
                                                                          forIndexPath:indexPath];
    Photo *photo;
    photo = [[[[self journal] photos] allObjects] objectAtIndex:indexPath.item];
    
    
//    Photo *photo = [[[[self journal] photos] allObjects] objectAtIndex:indexPath.row - 1];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[collectionView frame]];
    [[imageView layer] setMasksToBounds:YES];
    [[imageView layer] setCornerRadius:5];
//    NSLog(@"%d %f %f", indexPath.row, imageView.frame.size.width, imageView.frame.size.width);
    [imageView setImage:[[photo image] valueForKey:@"image"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [cell setBackgroundView:imageView];
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//
//}

@end
