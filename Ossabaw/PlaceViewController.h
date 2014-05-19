//
//  PlaceViewController.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/4/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceChildViewController.h"

@interface PlaceViewController : UIViewController <UIPageViewControllerDataSource>
{
    UIPageViewController *pageViewController;
    UILabel *label;
    UIPageControl *pageControl;
    UITextView *captionView;
    
    NSArray *images;
    NSString *info;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UITextView *captionView;

@property NSArray *images;
@property NSString *info;

-(id) initWithImages: (NSArray *)theImages info:(NSString *)theInfo label:(NSString *) theLabel;
@end
