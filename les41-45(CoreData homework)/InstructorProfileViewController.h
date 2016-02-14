//
//  InstructorProfileViewController.h
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 07/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Instructor+CoreDataProperties.h"

@interface InstructorProfileViewController : UIViewController

@property (strong, nonatomic) Instructor *instructor;

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
