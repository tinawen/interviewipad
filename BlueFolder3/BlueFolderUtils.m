//
//  BlueFolderUtils.m
//  BlueFolder3
//
//  Created by tina on 10/8/12.
//  Copyright (c) 2012 tina. All rights reserved.
//

#import "BlueFolderUtils.h"

@implementation BlueFolderUtils

+ (NSString *)serverAddress
{
    return @"http://interview.dev.corp.dropbox.com:8080/";
}

+ (NSString *)intervieweeSelectedNotification
{
    return @"BlueFolderIntervieweeSelectedNotification";
}

+ (NSString *)takeIntervieweePictureNotification
{
    return @"BlueFolderTakeIntervieweePictureNotification";
}

+ (NSString *)getIntervieweesURL
{
    return [NSString stringWithFormat:@"%@interviewees", [BlueFolderUtils serverAddress]];
}

+ (NSString *)nextInterviewerInfoURL
{
    return [NSString stringWithFormat:@"%@next_interviewer_info", [BlueFolderUtils serverAddress]];
}

+ (void)informNextInterviewerWithCurrentInterviewer:(NSString *)interviewer interviewee:(NSString *)interviewee
{
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:interviewer, @"interviewer", interviewee, @"interviewee", nil];
    if([NSJSONSerialization isValidJSONObject:jsonDictionary])
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@contact_next_interviewer", [BlueFolderUtils serverAddress]]]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        
        NSHTTPURLResponse *response = NULL;
        NSError *error = NULL;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *title = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"title is %@", title);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

+ (void)displayAlertWithMessage:(NSString *)alertMsg
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:alertMsg message:@"Maybe check if the server is down?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
}

+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

@end
