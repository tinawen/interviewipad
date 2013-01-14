//
//  BlueFolderFeedbackViewController.h
//  BlueFolder3
//
//  Created by tina on 10/8/12.
//  Copyright (c) 2012 tina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlueFolderRequest;
@interface BlueFolderFeedbackViewController : UIViewController 
{
    IBOutlet UILabel *nextInterviewerNameLabel;
    IBOutlet UILabel *intervieweePositionLabel;
    IBOutlet UILabel *timeStampLabel;
    IBOutlet UIView *nextInterviewerView;
    IBOutlet UIImageView *intervieweeImageView;
    IBOutlet UIImageView *nextInterviewerImage;
    IBOutlet UILabel *intervieweeNameLabel;
    IBOutlet UILabel *nextInterviewerCellLabel;
    IBOutlet UILabel *callLabel;
    IBOutlet UITextView *questionTextView;
    NSString *intervieweeName;
    NSString *intervieweePosition;
    NSString *interviewerName;
    UIImage *intervieweeImage;
    UIImageView *yesButtonImageView;
    UIImageView *noButtonImageView;
    BOOL yesSelected;
    BOOL noSelected;
    UIButton *submitButton;
    BlueFolderRequest *request;
}

- (id)initWithIntervieweeName:(NSString *)intName intervieweePosition:(NSString *)intPosition currentInterviewerName:(NSString *)intwerName intervieweeImage:(UIImage *)intweeImage;

@end
