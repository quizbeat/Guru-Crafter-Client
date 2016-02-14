//
//  AddCourseViewController.h
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 06/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course+CoreDataProperties.h"

typedef NS_ENUM(NSInteger, ViewMode) {
    AddMode,
    EditMode,
};

@interface AddCourseViewController : UITableViewController

- (IBAction)actionDoneButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)actionCancellButtonPressed:(UIBarButtonItem *)sender;

@property (assign, nonatomic) ViewMode viewMode;
@property (strong, nonatomic) Course *course;

@end
