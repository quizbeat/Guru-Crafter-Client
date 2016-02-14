//
//  CourseProfileViewController.h
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 06/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course+CoreDataProperties.h"

@interface CourseProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructorNameLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Course *course;

@end
