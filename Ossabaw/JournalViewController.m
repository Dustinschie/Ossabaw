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

@synthesize pageControl, scrollView, textView, place, button;

-(void) viewDidLoad
{
    [super viewDidLoad];

    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self setTitle: (NSString *)[place objectForKey:@"Name"]];
    
    [[self textView] setText:(NSString *)[place objectForKey:@"Information"]];
    [[self textView] setEditable:NO];
    
    [[self scrollView] setDelegate:self];
    [[self scrollView] setPagingEnabled:YES];
    [[self scrollView] setAlwaysBounceVertical:NO];
    [[self scrollView] setAlwaysBounceHorizontal:YES];
    
    NSInteger numberOfViews = [[place objectForKey:@"Images"] count];
    
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * [[self scrollView] frame].size.width;
        UIImageView *image = [[UIImageView alloc] initWithFrame:
                              CGRectMake(xOrigin, 0,
                                         [[self scrollView] frame].size.width,
                                         [[self scrollView] frame].size.height)];
        [image setImage: [UIImage imageNamed: [[place objectForKey:@"Images"] objectAtIndex: i]]];
        [image setContentMode: UIViewContentModeScaleAspectFill];
        [[self scrollView] addSubview:image];
    }
    //set the scroll view content size
    self.scrollView.contentSize = CGSizeMake([[self scrollView] frame].size.width * numberOfViews,
                                             [[self scrollView] frame].size.height);

   }

-(IBAction)buttonPressed:(id)sender
{
    NSString *alertViewText = @"Camera Implementation";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:alertViewText delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alert show];
}

- (void) viewDidAppear:(BOOL)animated
{
        [super viewDidAppear:animated];
//    [[self pageControl] setNumberOfPages: numberOfViews];
    
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

@end
