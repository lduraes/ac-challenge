//
//  UIView+AVCExtensions.h
//  ACTest
//
//  Created by Luiz Duraes on 3/26/16.
//  Copyright © 2016 Mob4U IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AVCExtensions)

-(void)hideViewNoRecordsFound;
-(void)showViewNoRecordsFound;
-(void)showViewWithMessage:(NSString *)errMessage;

@end
