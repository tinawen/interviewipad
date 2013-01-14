//
//  BlueFolderAppDelegate.h
//  BlueFolder3
//
//  Created by tina on 10/6/12.
//  Copyright (c) 2012 tina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlueFolderIntervieweeTableViewController;
@interface BlueFolderAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readwrite, retain) BlueFolderIntervieweeTableViewController *viewController;

@end
