//
//  BlueFolderButton.m
//  BlueFolder3
//
//  Created by tina on 1/10/13.
//  Copyright (c) 2013 tina. All rights reserved.
//

#import "BlueFolderButton.h"

@implementation BlueFolderButton

@synthesize iconView;
@synthesize label;

- (id)initWithFrame:(CGRect)frame icon:(UIImage *)image label:(NSString *)labelText
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[self iconView] setImage:image];
        [[self label] setText:labelText];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
