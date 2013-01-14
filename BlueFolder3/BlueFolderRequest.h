//
//  BlueFolderRequest.h
//  BlueFolder3
//
//  Created by tina on 1/13/13.
//  Copyright (c) 2013 tina. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BlueFolderRequestDelegate;

@interface BlueFolderRequest : NSObject
{
    NSMutableData *responseData;
    NSURL *baseURL;
    id<BlueFolderRequestDelegate> delegate;
}

@property (nonatomic, assign) id<BlueFolderRequestDelegate> delegate;

- (void)sendRequestWithURL:(NSString *)urlString withParams:(NSDictionary *)params;

@end

@protocol BlueFolderRequestDelegate <NSObject>

- (void)restClientLoadedData:(NSDictionary* )data forRequest:(NSURLRequest *)request;
- (void)restClientFailedWithError:(NSError *)error forRequest:(NSURLRequest *)request;
@end