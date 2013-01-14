//
//  BlueFolderUtils.h
//  BlueFolder3
//
//  Created by tina on 10/8/12.
//  Copyright (c) 2012 tina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlueFolderUtils : NSObject

+ (NSString *)serverAddress;
+ (NSString *)intervieweeSelectedNotification;
+ (NSString *)takeIntervieweePictureNotification;
+ (NSString *)getIntervieweesURL;
+ (NSString *)nextInterviewerInfoURL;
+ (void)informNextInterviewerWithCurrentInterviewer:(NSString *)interviewer interviewee:(NSString *)interviewee;
+ (void)displayAlertWithMessage:(NSString *)alertMsg;

+ (NSString*)base64forData:(NSData*)theData;

@end
