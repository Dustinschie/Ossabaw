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

    [[self textView] setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [[self menuButton] initAnimationWithFadeEffectEnabled:YES];
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *menuItemsVC = (UIViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"ExpandMenu"];
    [self setMenuItemView:(BounceButtonView *)[menuItemsVC view]];
    NSArray *arrMenuItemButtons = [[NSArray alloc] initWithObjects: [[self menuItemView] facebookButton],
                                                                    [[self menuItemView] pinterest],
                                                                    [[self menuItemView] googleplus],
                                                                    [[self menuItemView] twitterButton], nil];
    //  add all the defined 'menu' buttons to menu item view
    [[self menuItemView] addBounceButtons:arrMenuItemButtons];
    //  set the bouncing distance, speed, and fade-out effect duration here. Refer to the ASOBounceButtonView public properties
    [[self menuItemView] setBouncingDistance:[NSNumber numberWithFloat:0.7f]];
    [self.menuItemView setSpeed:[NSNumber numberWithFloat:0.3f]];
    [self.menuItemView setBouncingDistance:[NSNumber numberWithFloat:0.3f]];
    //  set as delegate of 'menu item view'
    [[self menuItemView] setDelegate:self];
    
    UIImage *bgImage = [[ UIImage imageNamed:@"sky.png"]applyLightEffect];
    [[self backgroundImageView] setImage:bgImage];
    [[self view] sendSubviewToBack:[self backgroundImageView]];
    

}

- (void) viewWillAppear:(BOOL)animated
{
    [[self collectionView] reloadData];

    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [super viewWillAppear:animated];
    int num_of_photos = 1;
    if ([self journal] != nil) {
        [self setTitle:[[self journal] title]];
        [[self textView] setText:[[self journal] information]];
         num_of_photos = [[[self journal] photos] count];
    }
    else if([self place] != nil){

        [self setTitle:[place objectForKey:@"Name"]];
        [[self textView] setText:[place objectForKey:@"Information"]];
        NSArray *images = [[self place] objectForKey:@"Images"];
        num_of_photos = [images count];
    }
    [[self pageControl] setNumberOfPages:num_of_photos];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //  tell menu button position to menu item view
    [[self menuItemView] setAnimationStartFromHere:[[self menuButton] frame]];
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

- (IBAction)menuButtonAction:(id)sender
{
    if ([sender isOn]) {
        //  show menu item view and expand its meni item button
        [[self menuButton] addCustomView:[self menuItemView]];
        [[self menuItemView] expandWithAnimationStyle:ASOAnimationStyleRiseProgressively];
    } else{
        //  collapse all 'menu item button' and remove 'menu item view'
        [[self menuItemView] collapseWithAnimationStyle:ASOAnimationStyleRiseProgressively];
        [[self menuButton] removeCustomView:[self menuItemView] interval:[[[self menuItemView]collapsedViewDuration] doubleValue]];
    }
    
}

//----------------------------------------------------------------------------------------------
// Crop image to specifications in rect
- (UIImage *) cropImage: (UIImage *) image toRect:(CGRect) rect
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
    
    if (tappedCellPath){
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
- (void) displayEmailComposerSheet
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    [mailComposer setMailComposeDelegate:self];
    NSString *date = [NSDateFormatter localizedStringFromDate:[journal date]
                                                    dateStyle:NSDateFormatterShortStyle
                                                    timeStyle:NSDateFormatterNoStyle];
    [mailComposer setSubject:[NSString stringWithFormat:@"Ossabaw Island Journal: %@ on %@", [journal title], date]];
    //  Add photos to insert
    NSInteger i = 0;
    for (Photo *photo in [journal photos]) {
        UIImage *image = [[photo image] valueForKey:@"image"];
        //  convert image into data
        NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.0)];
        //  add Data to mail composer as an attachment
        [mailComposer addAttachmentData:imageData mimeType:@"image/jpeg"
                               fileName:[NSString stringWithFormat:@"%d.png", i]];
        i++;
    }
    //  create the mail compser window
    [mailComposer setMessageBody:[journal information] isHTML:NO];
    [self presentViewController:mailComposer animated:YES completion:nil];

}
- (void) displaySMSComposerSheet
{
    if ([MFMessageComposeViewController canSendAttachments] && [MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageComposer = [[MFMessageComposeViewController alloc] init];
        if ([MFMessageComposeViewController canSendSubject])
            [messageComposer setSubject:[journal title]];
        [messageComposer setBody:[journal information]];
        [messageComposer setMessageComposeDelegate:self];
        NSInteger i = 0;
        for (Photo *photo in [journal photos]) {
            UIImage *image = [[photo image] valueForKey:@"image"];
            //  convert image into data
            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
            //  add Data to mail composer as an attachment
            [messageComposer addAttachmentData:imageData typeIdentifier:(NSString *)kUTTypePNG
                                      filename:[NSString stringWithFormat:@"%d.png", i]];
            i++;
        }
        [self presentViewController:messageComposer animated:YES completion:nil];
    } else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem!"
                                                            message:@"Device is unable to send message"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles: nil];
        [alertView show];
    }
}
#pragma mark -MFMailComposeViewControllerDelegate
//----------------------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    NSString *message;
    switch (result) {
        case MFMailComposeResultSaved:
            message = @"Draft saved for later";
            break;
        case MFMailComposeResultSent:
            message = @"Draft sent";
            break;
        case MFMailComposeResultFailed:
            message = @"Message failed";
            break;
        default:
            break;
    }
    if (message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    if (![[self presentedViewController] isBeingDismissed])
        [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark -MFMailComposeViewControllerDelegate
//----------------------------------------------------------------------------------------------
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    NSString *message = (result == MessageComposeResultFailed ? @"Message failed" : nil);
    if (message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
    if (![[self presentedViewController] isBeingDismissed])
        [self dismissViewControllerAnimated:YES completion:nil];
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

- (void) journalEntryMakerViewController:(JournalEntryMakerViewController *)journalEntryMakerViewController didAddJournal:(Journal *)ajournal
{
    if (![[self presentedViewController] isBeingDismissed]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self journal] != nil) {
        return [[[self journal] photos] count];
    }
    return [[[self place] objectForKey:@"Images"] count];

}

- (UICollectionViewCell *) collectionView:(UICollectionView *)acollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [acollectionView dequeueReusableCellWithReuseIdentifier:@"collectionCellID"
                                                                          forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[acollectionView frame]];
    [[imageView layer] setMasksToBounds:YES];
    [[imageView layer] setCornerRadius:5];
    if (journal != nil) {
        Photo *photo;
        photo = [[[[self journal] photos] allObjects] objectAtIndex:indexPath.item];
        [imageView setImage:[[photo image] valueForKey:@"image"]];
    } else{
        
        UIImage *image = [UIImage imageNamed:[[[self place] objectForKey:@"Images"] objectAtIndex:indexPath.row]];
        [imageView setImage:image];
    }
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [cell setBackgroundView:imageView];
    return cell;
}

#pragma mark -Menu item view delegate method
- (void)didSelectBounceButtonAtIndex:(NSUInteger)index
{
    //  Collapse all menu item buttons and remove menu item view once a menu item is selected
    [[self menuButton] sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    NSString *serviceType;
    int i = index;
    switch (i) {
        case 0:
            serviceType = SLServiceTypeFacebook;
            break;
        case 1:
            [self displaySMSComposerSheet];
            break;
        case 2:
            [self displayEmailComposerSheet];
            break;
        case 3:
            serviceType = SLServiceTypeTwitter;
            break;
        default:
        {
            
            //  set your custom action for each selected menu item button
            NSString *alertViewTitle = [NSString stringWithFormat:@"Menu Item %x is selected", (short)index];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertViewTitle message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            break;
        }
    }
    if (serviceType && [SLComposeViewController isAvailableForServiceType:serviceType]) {
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        [vc setInitialText: [journal information]];
        for (Photo *photo in [journal photos]) {
            UIImage* image = [[photo image] valueForKey:@"image"];
            [vc addImage:image];
        }
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [[self menuItemView] setAnimationStartFromHere:[[self menuButton] frame]];
}

@end
