//
//  JournalViewController.m
//  Ossabaw
//
//  Created by Dustin Schie on 4/8/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import "JournalViewController.h"

//  where we add private attributes
@interface JournalViewController ()
//  We are all consenting adults here
@end

@implementation JournalViewController

@synthesize     place,
                journal,
                textView,
                editButton,
                menuButton,
                pageControl,
                menuItemView,
                collectionView,
                backgroundImageView;

#pragma mark- viewControllerDelegate
-(void) viewDidLoad
{
    [super viewDidLoad];
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *menuItemsVC = (UIViewController *)
    [mainStoryBoard instantiateViewControllerWithIdentifier:@"ExpandMenu"];
    //  set menu item with the Bounce button view created in the StoryBoard
    [self setMenuItemView:(BounceButtonView *)[menuItemsVC view]];
    
    //  create array of buttons
    NSArray *arrMenuItemButtons = [[NSArray alloc] initWithObjects: [[self menuItemView] facebookButton],
                                                                    [[self menuItemView] pinterest],
                                                                    [[self menuItemView] googleplus],
                                                                    [[self menuItemView] twitterButton], nil];
    //  initialize menuButton with Fade Effect enabled
    [[self menuButton] initAnimationWithFadeEffectEnabled:YES];
    //  add all the defined 'menu' buttons to menu item view
    [[self menuItemView] addBounceButtons:arrMenuItemButtons];
    //  set the bouncing distance, speed, and fade-out effect duration here.
    //  Refer to the ASOBounceButtonView public properties
    [[self menuItemView] setBouncingDistance:[NSNumber numberWithFloat:0.7f]];
    [self.menuItemView setSpeed:[NSNumber numberWithFloat:0.3f]];
    [self.menuItemView setBouncingDistance:[NSNumber numberWithFloat:0.3f]];
    //  set as delegate of 'menu item view'
    [[self menuItemView] setDelegate:self];
    
    //  create a background image from the with a dark-blurred effect
    UIImage *bgImage = [[ UIImage imageNamed:@"sky.png"]applyDarkEffect];
    //  set the backgroundImageView with the background image
    [[self backgroundImageView] setImage:bgImage];
    //  push the above imageView to the back of the 'main' view
    [[self view] sendSubviewToBack:[self backgroundImageView]];
}
//----------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //everytime the view is about to appear do:
    //  reload collection view
    [[self collectionView] reloadData];
    //  prevent the the navBar from hiding (Just in case the previous view controller has it hidden)
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    int num_of_photos = 1;
    //  if this JournalViewController is using info from CoreData set Title and TextView
    if ([self journal] != nil) {
        [self setTitle:[[self journal] title]];
        [[self textView] setText:[[self journal] information]];
         num_of_photos = [[[self journal] photos] count];
    }
    //  otherwise, if the JournalViewController is using the 'place' Dictionary, do the same as above
    else if([self place] != nil){
        [self setTitle:[place objectForKey:@"Name"]];
        [[self textView] setText:[place objectForKey:@"Information"]];
        NSArray *images = [[self place] objectForKey:@"Images"];
        num_of_photos = [images count];
    }
    //  set the number of pages (dots) in the page control
    [[self pageControl] setNumberOfPages:num_of_photos];
}
//----------------------------------------------------------------------------------------------
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //  tell menu button position to menu item view
    [[self menuItemView] setAnimationStartFromHere:[[self menuButton] frame]];
}
//----------------------------------------------------------------------------------------------
-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //  once the view disappears, clear the title, place and TextView, and reload the collectionView
    [self setTitle:nil];
    [self setTextView:nil];
    [self setPlace:nil];
    [[self collectionView] reloadData];
    
}
//----------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - segue preperation handling
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //  if the segue is taking the user to the Journal Entry Maker View Controller do:
    if ([[segue identifier] isEqualToString:@"blurToEdit"])
    {
        // grab the Journal entry Maker View Controller from this segue's destinationViewController
        JournalEntryMakerViewController *jemvc = (JournalEntryMakerViewController *) segue.destinationViewController;
        //  set this view Controller as the delegate for the upcoming one
        [jemvc setDelegate:self];
        //  set jemvc's journal and tell it that it is not a new Journal
        [jemvc setJournal:[self journal] andIsNewJournal:NO];
        //  grab the segue
        BlurryModalSegue* bms = (BlurryModalSegue*)segue;
        //  set the segue's Image saturation
        [bms setBackingImageSaturationDeltaFactor:@(0.45)];
        
    }
    //  else if the segue is taking the user to the Image Collection View Controller
    else if ([[segue identifier] isEqualToString:@"blurToImage"]){
        //  grav the Image Collection View controller from this segue's destinationViewController
        ImageCollectionViewController* icvc = (ImageCollectionViewController *) segue.destinationViewController;
        //  set the Journal Core data from this view Controller
        [icvc setJournal:journal];
        /**--BEWARE CORE GRAPHICS AHEAD--*/
        //  set image Context
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        //  render main view's layer in the graphic's context
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        //  set an image from the context
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //  end context
        UIGraphicsEndImageContext();
        //  apply a light blur effect
        image = [image applyLightEffect];
        //  initialize an imageView with the above image
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        //  set background of the upcoming view controller's collectionView
        [[icvc collectionView] setBackgroundView:imageView];
    }
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (journal == nil) {
        return NO;
    }
    return YES;
}
#pragma mark - Interface Builder Actions
- (IBAction)editButtonPressed:(id)sender
{
    //  when the edit button is pressend preform a segue
    [self performSegueWithIdentifier:@"blurToEdit" sender:self];
}
//----------------------------------------------------------------------------------------------
- (IBAction)menuButtonAction:(id)sender
{
    //  if the sender (Two-State button) is in the 'ON' position
    if ([sender isOn]) {
        //  show menu item view and expand its meni item button
        [[self menuButton] addCustomView:[self menuItemView]];
        [[self menuItemView] expandWithAnimationStyle:ASOAnimationStyleRiseProgressively];
    } else{
        //  collapse all 'menu item button' and remove 'menu item view'
        [[self menuItemView] collapseWithAnimationStyle:ASOAnimationStyleRiseProgressively];
        [[self menuButton] removeCustomView:[self menuItemView]
                                   interval:[[[self menuItemView]collapsedViewDuration] doubleValue]];
    }
    
}
#pragma mark - display Functions
- (void) displayEmailComposerSheet
{
    if ([MFMailComposeViewController canSendMail]) {
        //  initialized the Mail ComposeView Controller
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        //  set its delegate to the current View Controller
        [mailComposer setMailComposeDelegate:self];
        //  create a string object from the journal's date object
        NSString *date = [NSDateFormatter localizedStringFromDate:[journal date]
                                                        dateStyle:NSDateFormatterShortStyle
                                                        timeStyle:NSDateFormatterNoStyle];
        //  awr rgw subject to the mailComposer
        [mailComposer setSubject:[NSString stringWithFormat:@"Ossabaw Island Journal: %@ on %@", [journal title], date]];
        //  Add photos to email
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
        //  set Message body of mailComposer
        [mailComposer setMessageBody:[journal information] isHTML:NO];
        //   present the mailComposer View Controller
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
    //  if the mailComposer is unable to send mail, show an alert view to notify the user
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem!"
                                                            message:@"Device is unable to send email"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles: nil];
        [alertView show];
    }

}
//----------------------------------------------------------------------------------------------
- (void) displaySMSComposerSheet
{
    if ([MFMessageComposeViewController canSendAttachments] && [MFMessageComposeViewController canSendText]) {
        //  initialize the MessageComposeViewController
        MFMessageComposeViewController *messageComposer = [[MFMessageComposeViewController alloc] init];
        //  if messageComposer can send subjects, send the title of the journal CoreData object
        if ([MFMessageComposeViewController canSendSubject])
            [messageComposer setSubject:[journal title]];
        //  set the body of messageComposer
        [messageComposer setBody:[journal information]];
        //  set messageComposer's delegate to the current current view controller
        [messageComposer setMessageComposeDelegate:self];
        //  add photos to message
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
        //  present the messageComposer view Controller
        [self presentViewController:messageComposer animated:YES completion:nil];
    }
    //  if the messageComposer is either unable to send attachments or unable to send texts,
    //  show an alert view to notify the user
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Problem!"
                                                            message:@"Device is unable to send message"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles: nil];
        [alertView show];
    }
}

#pragma mark -MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    // handle the results, if it meets one of the following cases, create an alert view to
    //  notify the user
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
    
    //  dismiss the MailComposeViewController
    if (![[self presentedViewController] isBeingDismissed])
        [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark -MFMailComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    //  if the message failed, alert the user.
    NSString *message = (result == MessageComposeResultFailed ? @"Message failed" : nil);
    if (message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles: nil];
        [alert show];
    }
    //  dismiss the MessageComposeViewController
    if (![[self presentedViewController] isBeingDismissed])
        [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)aScrollView
{
    //  get the width of the scroll view
    CGFloat viewWidth = [aScrollView frame].size.width;
    //  get the number of view in scroll view
    int numViews = [[aScrollView subviews] count];
    //  get the current page number
    int pageNumber = (int)floor(([aScrollView contentOffset].x - viewWidth / numViews) / viewWidth + 1)
                        % [[self pageControl] numberOfPages];
    //  set current page of pageControl
    [[self pageControl] setCurrentPage:pageNumber];
}
#pragma mark - journal support
- (void) journalEntryMakerViewController:(JournalEntryMakerViewController *)journalEntryMakerViewController
                           didAddJournal:(Journal *)ajournal
{
    // dismiss journalEntryMalerViewController
    if (![[self presentedViewController] isBeingDismissed]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    // if the journal is not empty
    if ([self journal] != nil) {
        return [[[self journal] photos] count];
    }
    return [[[self place] objectForKey:@"Images"] count];

}

- (UICollectionViewCell *) collectionView:(UICollectionView *)acollectionView
                   cellForItemAtIndexPath:(NSIndexPath *)indexPath
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
    //  handle index,   cases 0 & 3:  set the service type to 'X'
    //                  cases 1 & 2:  call corresponding composer sheet
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
        {   //  set your custom action for each selected menu item button
            NSString *alertViewTitle = [NSString stringWithFormat:@"Menu Item %x is selected", (short)index];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertViewTitle
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
    // if you have a service type and that service type is available, do it.
    if (serviceType && [SLComposeViewController isAvailableForServiceType:serviceType]) {
        //  create SL compose View Controller
        SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        //  set initial text
        [vc setInitialText: [journal information]];
        //  add photos
        for (Photo *photo in [journal photos]) {
            UIImage* image = [[photo image] valueForKey:@"image"];
            [vc addImage:image];
        }
        //  present the view controller
        [self presentViewController:vc animated:YES completion:nil];
    }
}
//----------------------------------------------------------------------------------------------
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [[self menuItemView] setAnimationStartFromHere:[[self menuButton] frame]];
}

@end
