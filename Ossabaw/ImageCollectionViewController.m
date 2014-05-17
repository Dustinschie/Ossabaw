//
//  ImageCollectionViewController.m
//  Ossabaw
//
//  Created by Dustin Schie on 5/13/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import "ImageCollectionViewController.h"

@interface ImageCollectionViewController ()

@end

@implementation ImageCollectionViewController
@synthesize journal;

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
//    UICollectionViewFlowLayout *layout = (id) self.collectionView.collectionViewLayout;
//    layout.itemSize = self.collectionView.frame.size;
    
    // Do any additional setup after loading the view
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[journal photos] count];
}
- (UICollectionViewCell *) collectionView:(UICollectionView *)acollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewCell *cell = [acollectionView dequeueReusableCellWithReuseIdentifier:@"collectionCellID"forIndexPath:indexPath];
    
    Photo *photo;
    photo = [[[[self journal] photos] allObjects] objectAtIndex:indexPath.row];
    
    
    //    Photo *photo = [[[[self journal] photos] allObjects] objectAtIndex:indexPath.row - 1];
    UIImage *image = [[photo image] valueForKey:@"image"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[cell frame]];
    [[imageView layer] setMasksToBounds:YES];
    [[imageView layer] setCornerRadius:5];
    [imageView  setContentMode:UIViewContentModeScaleAspectFit];
    
    [imageView setImage:image];
    
    //    NSLog(@"%d %f %f", indexPath.row, imageView.frame.size.width, imageView.frame.size.width);
    
//    [[cell contentView] setContentMode:UIViewContentModeScaleAspectFit];
    for (UIView *view in [[cell contentView] subviews])
        [view removeFromSuperview];
    
//    [[cell contentView] addSubview:imageView];
    [[cell contentView] setContentMode:UIViewContentModeScaleAspectFit];
    
//    NSLog(@"hello %f %f %d", [cell.contentView.subviews[0] frame].size.width, [cell.contentView.subviews[0] frame].size.height, indexPath.row);
    [cell setBackgroundView:imageView];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

-(BOOL)             collectionView:(UICollectionView *)collectionView
  shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(BOOL) collectionView:(UICollectionView *)collectionView
      canPerformAction:(SEL)action
    forItemAtIndexPath:(NSIndexPath *)indexPath
            withSender:(id)sender
{
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}
- (void) collectionView:(UICollectionView *)collectionView
          performAction:(SEL)action
     forItemAtIndexPath:(NSIndexPath *)indexPath
             withSender:(id)sender
{
    if (action == @selector(copy:)) {
        UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        UIImageView *imageView =(UIImageView *)[[[cell contentView] subviews] objectAtIndex:0];
        [[UIPasteboard generalPasteboard] setImage: [imageView image]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
