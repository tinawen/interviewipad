//
//  BlueFolderButton.h
//  BlueFolder3
//
//  Created by tina on 1/10/13.
//  Copyright (c) 2013 tina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlueFolderButton : UIControl
{
    IBOutlet UIImageView *iconView;
    IBOutlet UILabel *label;
}

@property (nonatomic, assign) UIImageView *iconView;
@property (nonatomic, assign) UILabel *label;

@end

