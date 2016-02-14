//
//  AddStudentViewController.h
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 02/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student+CoreDataProperties.h"
#import "Course+CoreDataProperties.h"

typedef NS_ENUM(NSInteger, ViewMode) {
    AddMode,
    EditMode,
};

@interface AddStudentViewController : UITableViewController

- (IBAction)actionCancelButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)actionDoneButtonPressed:(UIBarButtonItem *)sender;

@property (assign, nonatomic) ViewMode viewMode;
@property (strong, nonatomic) Student *student;

@end
