//
//  Photo.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/27/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Journal;
@interface ImageToDataTransformer : NSValueTransformer
@end

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Journal *journal;
@property (nonatomic, retain) NSManagedObject *image;

@end
