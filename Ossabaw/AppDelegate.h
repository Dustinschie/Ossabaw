//
//  AppDelegate.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/1/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//
/**
 This is the AppDelegate for this application. this file, and its implementation, are
 created automatically during project creation. These are the first files to be executed.
 Consider them like a bootstrap for the application.
 This deals with the the main "Delegate"
 notifications for the application like:
 -   When the application finished loading and is ready for the user to add the first
 View controller.
 -   When the application terminates.
 The application delefate is one of the most important files in your project!
 */

#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController* tabBarController;
@property (readonly, nonatomic) NSManagedObjectContext  *managedObjectContext;
@property (readonly, nonatomic) NSManagedObjectModel    *managedObjectModel;
@property (readonly, nonatomic) NSPersistentStoreCoordinator    *persistentStoreCoordinator;

@end
