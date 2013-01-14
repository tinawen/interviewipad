//
//  BlueFolderIntervieweeTableViewController.h
//  BlueFolder3
//
//  Created by tina on 10/7/12.
//  Copyright (c) 2012 tina. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"
@class BlueFolderRequest;

@interface BlueFolderIntervieweeTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    EGORefreshTableHeaderView *refreshHeaderView;
    BOOL reloading;
    NSArray* dataArray;
    UIImagePickerController *picker;
    NSString *intervieweeSelected;
    BlueFolderRequest *request;
}

@end
