//
//  AddCourseViewController.m
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 06/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import "AddCourseViewController.h"
#import "SelectItemsViewController.h"
#import "UIAlertController+ErrorAlert.h"
#import "EntityInfoCell.h"

#import "CoreDataManager.h"
#import "Instructor+CoreDataProperties.h"
#import "Student+CoreDataProperties.h"


typedef NS_ENUM(NSInteger, CourseInfoTextFieldTag) {
    CourseInfoTextFieldName,
};


@interface AddCourseViewController () <SelectItemsDelegate, UITextFieldDelegate>

@end


@implementation AddCourseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.viewMode == AddMode) {
        self.navigationItem.title = @"Add course";
        NSManagedObjectContext *context = [[CoreDataManager sharedManager] managedObjectContext];
        Course *course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
        self.course = course;
        
    } else {
        self.navigationItem.title = @"Edit course";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Data actions

- (void)addInstructor
{
    SelectItemsViewController *vc = [[SelectItemsViewController alloc] init];
    if (self.course.instructor) {
        vc.selectedItems = [NSMutableSet setWithObject:self.course.instructor];
    }
    vc.selectionType = SelectionTypeSingle;
    vc.itemsKind = ItemsKindInstructor;
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addStudents
{
    SelectItemsViewController *vc = [[SelectItemsViewController alloc] init];
    vc.selectedItems = [self.course.students copy];
    vc.selectionType = SelectionTypeMultiple;
    vc.itemsKind = ItemsKindStudent;
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteCourseWithConfirmation:(BOOL)confirmation
{
    if (confirmation) {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete course" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deleteCourse];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:deleteAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        [self deleteCourse];
    }
}

- (void)deleteCourse
{
    [[[CoreDataManager sharedManager] managedObjectContext] deleteObject:self.course];
    [[CoreDataManager sharedManager] saveContext];
}



#pragma mark - Data validation

- (BOOL)courseInfoIsValid
{
    NSString *name = [self nameInfo];
    if (name == nil || [name isEqualToString:@""]) {
        return NO;
    }
    
    if (self.course.instructor == nil) {
        return NO;
    }
    
    return YES;
}

- (NSString *)nameInfo
{
    EntityInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    NSString *name = cell.infoTextField.text;
    return name;
}



#pragma mark - UI Actions

- (IBAction)actionDoneButtonPressed:(UIBarButtonItem *)sender
{    
    if ([self courseInfoIsValid]) {
        self.course.name = [self nameInfo];
        
        [[CoreDataManager sharedManager] saveContext];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController errorAlertWithTitle:@"Error" message:@"Please enter all info"];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}

- (IBAction)actionCancellButtonPressed:(UIBarButtonItem *)sender
{
    if (self.viewMode == AddMode) {
        [self deleteCourseWithConfirmation:NO];
    } else {
        [[[CoreDataManager sharedManager] managedObjectContext] rollback];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.viewMode == AddMode) {
        return 2;
    } else if (self.viewMode == EditMode) {
        return 3;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1 + [self.course.students count];
    } else if (section == 2) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSInteger row = indexPath.row;
        if (row == 0) {
            EntityInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EntityInfoCell class])];
            
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EntityInfoCell class]) owner:nil options:nil];
                cell = [nib firstObject];
            }
            
            cell.infoTitleLabel.text = @"Name";
            cell.infoTextField.placeholder = @"Enter course name";
            cell.infoTextField.tag = CourseInfoTextFieldName;
            cell.infoTextField.keyboardType = UIKeyboardTypeDefault;
            cell.infoTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            cell.infoTextField.returnKeyType = UIReturnKeyDone;
            if (self.viewMode == EditMode) {
                cell.infoTextField.text = self.course.name;
            }
            
            cell.infoTextField.delegate = self;
            
            return cell;
            
        } else if (row == 1) {
            static NSString *identifier = @"CourseInstructorCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
            }
            cell.textLabel.text = @"Instructor";
            if (self.course.instructor) {
                NSString *instructorName = [NSString stringWithFormat:@"%@ %@", self.course.instructor.firstName, self.course.instructor.lastName];
                cell.detailTextLabel.text = instructorName;
            }
            return cell;
            
        } else {
            return nil;
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            static NSString *addCourseCellIdentifier = @"AddStudentsCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addCourseCellIdentifier];
            return cell;
            
        } else {
            static NSString *studentCellIdentifier = @"StudentCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:studentCellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:studentCellIdentifier];
            }
            Student *student = [[self.course.students allObjects] objectAtIndex:(indexPath.row - 1)];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
            return cell;
            
        }
    } else if (indexPath.section == 2) {
        static NSString *identifier = @"DeleteCourseCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        return cell;
        
    } else {
        return nil;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Main info";
    } else if (section == 1) {
        return @"Students";
    } else {
        return @"";
    }
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) { // Select instructor cell
        [self addInstructor];
    } else if (indexPath.section == 1 && indexPath.row == 0) { // Add students cell
        [self addStudents];
    } else if (indexPath.section == 2 && indexPath.row == 0) { // Delete course cell
        [self deleteCourseWithConfirmation:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return NO;
    }
    return YES;
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == CourseInfoTextFieldName) {
        [textField resignFirstResponder];
    }
    
    return YES;
}



#pragma mark - SelectItemsDelegate

- (void)selectItemsViewController:(SelectItemsViewController *)selectItemsVC didDoneSelectionForItemsKind:(ItemsKind)itemsKind items:(id)items
{
    if (itemsKind == ItemsKindInstructor) {
        [self.course setInstructor:items];
    } else if (itemsKind == ItemsKindStudent) {
        [self.course setStudents:items];
    }
}

- (void)selectItemsViewController:(SelectItemsViewController *)selectItemsVC didCancelSelectionForItemsKind:(ItemsKind)itemsKind items:(id)items
{
    NSLog(@"cancel");
}


@end
