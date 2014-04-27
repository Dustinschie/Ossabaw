//
//  Journal.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/27/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Journal : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) id icon;
@property (nonatomic, retain) NSString * information;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *photos;
@end

@interface Journal (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
