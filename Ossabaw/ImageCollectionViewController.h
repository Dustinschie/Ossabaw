//
//  ImageCollectionViewController.h
//  Ossabaw
//
//  Created by Dustin Schie on 5/13/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"
#import "Journal.h"
#import "Photo.h"
@interface ImageCollectionViewController : UICollectionViewController
@property (strong, nonatomic) Journal *journal;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

-(IBAction)close:(id)sender;
@end
