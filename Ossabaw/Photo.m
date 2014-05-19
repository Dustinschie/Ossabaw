//
//  Photo.m
//  Ossabaw
//
//  Created by Dustin Schie on 4/27/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import "Photo.h"
#import "Journal.h"


@implementation Photo

@dynamic name;
@dynamic journal;
@dynamic image;

@end
#pragma mark -
@implementation ImageToDataTransformer

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}

- (id)transformedValue:(id)value {
	NSData *data = UIImageJPEGRepresentation(value, 1.0f);
	return data;
}

- (id)reverseTransformedValue:(id)value {
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
	return uiImage;
}

@end