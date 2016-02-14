//
//  StudProfileViewController.m
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 08/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import "StudProfileViewController.h"
#import "AddStudentViewController.h"
#import "Student+CoreDataProperties.h"
#import "Course+CoreDataProperties.h"
#import "ProfileViewController.h"

@interface StudProfileViewController ()

@end

@implementation StudProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"Subclass initWithNibName called");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self initParentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)actionEditButtonPressed
{
    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddStudentNavigationController"];
    AddStudentViewController *vc = (AddStudentViewController *)navController.topViewController;
    vc.viewMode = EditMode;
    vc.student = (Student *)self.object;
    [self presentViewController:navController animated:YES completion:nil];
}

- (NSString *)textForCellTextLabelForObject:(NSManagedObject *)object
{
    return ((Course *)object).name;
}

- (NSString *)textForCellDetailTextLabelForObject:(NSManagedObject *)object
{
    Course *course = (Course *)object;
    NSString *text = [NSString stringWithFormat:@"%u students", [course.students count]];
    return text;
}

- (NSString *)textForFirstLabel
{
    return ((Student *)self.object).firstName;
}

- (NSString *)textForSecondLabel
{
    return ((Student *)self.object).lastName;
}

- (NSString *)textForThirdLabel
{
    return ((Student *)self.object).email;
}

- (NSArray *)tableViewItems
{
    Student *student = (Student *)self.object;
    return [student.courses allObjects];
}

@end
