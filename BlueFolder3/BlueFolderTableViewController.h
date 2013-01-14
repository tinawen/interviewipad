//
//  BlueFolderTableViewController.h
//  BlueFolder3
//
//  Created by tina on 10/6/12.
//  Copyright (c) 2012 tina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface BlueFolderTableViewController : UITableViewController
{
    EGORefreshTableHeaderView *refreshHeaderView;
    BOOL reloading;
    UITextField *textField;
    NSArray* dataArray;
    NSString *addEntryText;
    NSString *addEntryPlaceholderText;
    NSURL *refreshRequestURL;
    NSURL *addEntryRequestURL;
    BOOL canAddEntry;
}

@property (readwrite, retain) NSString *addEntryText;
@property (readwrite, retain) NSString *addEntryPlaceholderText;
@property (readwrite, retain) NSURL *refreshRequestURL;
@property (readwrite, retain) NSURL *addEntryRequestURL;
@property (readwrite, retain) NSArray *dataArray;
@property (readwrite, assign) BOOL canAddEntry;

- (void)refreshTableviewWithData:(NSData *)data;

@end
