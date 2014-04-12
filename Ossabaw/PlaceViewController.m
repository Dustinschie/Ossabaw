
//  PlaceViewController.m
//  Ossabaw
//
//  Created by Dustin Schie on 4/4/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import "PlaceViewController.h"

@interface PlaceViewController ()

@end

@implementation PlaceViewController

@synthesize pageViewController, images, info, label, pageControl, captionView;

-(id) initWithImages: (NSArray *)theImages info:(NSString *)theInfo label:(NSString *) theLabel
{
    self = [super init];
    
    [self setImages: theImages];
    [self setInfo: theInfo];
    [[self label] setText:theLabel];
    
    self.pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle: UIPageViewControllerTransitionStyleScroll
                               navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal
                               options: nil];
    
    [[self pageViewController] setDataSource: self];
    [[self pageControl] setNumberOfPages:[theImages count]];
    
    return  self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[[self pageViewController] view] setFrame: [[self view] bounds]];
    PlaceChildViewController *initViewController = [self viewControllerAtIndex: 0];
    NSArray *viewControllers = [NSArray arrayWithObject: initViewController];
    [[self pageViewController] setViewControllers: viewControllers
                               direction: UIPageViewControllerNavigationDirectionForward
                               animated: YES
                               completion: nil];

    [self addChildViewController: [self pageViewController]];
    [[self view] addSubview: [[self pageViewController] view]];
    [[self pageViewController] didMoveToParentViewController: self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [(PlaceChildViewController *)viewController index];
    index ++;
    if (index == 5)
        return nil;
    [[self pageControl] setCurrentPage:index];
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [(PlaceChildViewController *)viewController index];
    if (index == 0)
        return nil;
    index --;
    [[self pageControl] setCurrentPage:index];
    return [self viewControllerAtIndex:index];
}

-(PlaceChildViewController *)viewControllerAtIndex: (NSUInteger) index
{
    PlaceChildViewController *childViewController =[[PlaceChildViewController alloc]
                                            initWithNibName:@"PlaceChildViewController" bundle:nil];
    [childViewController setIndex: index];
    [[childViewController image] setImage:[UIImage imageNamed: self.images[index]]];
    
    return childViewController;
}

-(NSInteger) presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.images count];
}
-(NSInteger) presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}


@end
