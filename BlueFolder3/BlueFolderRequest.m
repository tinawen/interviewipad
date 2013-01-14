//
//  BlueFolderRequest.m
//  BlueFolder3
//
//  Created by tina on 1/13/13.
//  Copyright (c) 2013 tina. All rights reserved.
//

#import "BlueFolderRequest.h"
#import "BlueFolderUtils.h"

@implementation BlueFolderRequest

@synthesize delegate;

- (void)sendRequestWithURL:(NSString *)urlString withParams:(NSDictionary *)params
{
    NSData* requestData = NULL;
    if (params)
    {
        NSError *error;
        requestData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    } 
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];

    if (params)
    {
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"appliction/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
    }
    [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError *error = NULL;
    NSDictionary *content = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error:&error];

    if ([delegate respondsToSelector:@selector(restClientLoadedData:forRequest:)]) {
        [delegate restClientLoadedData:content forRequest:[connection originalRequest]];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Something went wrong when contacting the server" message:@"Maybe check if the server is down?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
    if ([delegate respondsToSelector:@selector(restClientFailedWithError:forRequest:)]) {
        [delegate restClientFailedWithError:error forRequest:[connection originalRequest]];
    }
}

@end
