//
//  AddInstructorViewController.h
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 07/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Instructor+CoreDataProperties.h"

typedef NS_ENUM(NSInteger, ViewMode) {
    AddMode,
    EditMode,
};

@interface AddInstructorViewController : UITableViewController

@property (strong, nonatomic) Instructor *instructor;
@property (assign, nonatomic) ViewMode viewMode;

- (IBAction)actionDoneButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)actionCancellButtonPressed:(UIBarButtonItem *)sender;

@end
