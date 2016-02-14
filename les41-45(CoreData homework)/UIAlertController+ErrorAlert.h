//
//  UIAlertController+ErrorAlert.h
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 14/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (ErrorAlert)

+ (instancetype)errorAlertWithTitle:(NSString *)title message:(NSString *)message;

@end
