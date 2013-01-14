//
//  BlueFolderInterviewerTableViewController.h
//  BlueFolder3
//
//  Created by tina on 10/7/12.
//  Copyright (c) 2012 tina. All rights reserved.
//

@class BlueFolderInterviewingViewController;
@interface BlueFolderInterviewerTableViewController : UITableViewController
{
    NSString *intervieweeName;
    NSString *intervieweePosition;
    NSString *intervieweeResume;
    UIImage *intervieweeImage;
    NSArray *questions;
    NSArray *interviewers;
    BlueFolderInterviewingViewController *interviewingViewController;
}

- (id)initWithIntervieweeName:(NSString *)intweeName intervieweePosition:(NSString *)intweePos intervieweeResume:(NSString *)intweeResume intervieweeImage:(UIImage *)intweeImage andInterviewers:(NSArray *)ints questions:(NSArray *)questions;

@end
