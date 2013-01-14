//
//  BlueFolderInterviewingViewController.h
//  BlueFolder3
//
//  Created by tina on 10/7/12.
//  Copyright (c) 2012 tina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlueFolderFeedbackViewController;
@class BlueFolderRequest;

@interface BlueFolderInterviewingViewController : UIViewController
{
    IBOutlet UILabel *candidateNameLabel;
    IBOutlet UILabel *positionLabel;
    IBOutlet UIButton *contactButton;
    IBOutlet UIWebView *webview;
    IBOutlet UIImageView *intervieweeImageView;
    IBOutlet UITableView* questionsTableView;
    IBOutlet UILabel *questionLabel;
    NSString *interviewer;
    NSString *intervieweeName;
    NSString *intervieweePosition;
    NSString *intervieweeResume;
    UIImage *intervieweeImage;
    NSArray *questions;
    BlueFolderRequest *request;
}

- (id)initWithInterviewer:(NSString *)curInterviewer andIntervieweeName:(NSString *)curIntervieweeName intervieweePosition:(NSString *)curIntervieweePos intervieweeResume:(NSString *)curIntervieweeResume intervieweeImage:(UIImage *)curIntervieweeImage questions:(NSArray *)questions;
@end
