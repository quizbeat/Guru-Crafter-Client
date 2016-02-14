//
//  UIAlertController+ErrorAlert.m
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 14/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import "UIAlertController+ErrorAlert.h"

@implementation UIAlertController (ErrorAlert)

+ (instancetype)errorAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okAction];
    return alert;
}

@end
