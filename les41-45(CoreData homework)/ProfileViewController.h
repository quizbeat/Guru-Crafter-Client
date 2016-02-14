//
//  ProfileViewController.h
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 08/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;

@property (weak, nonatomic) IBOutlet UIView *profileCardBackgroundView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSManagedObject *object;
@property (strong, nonatomic) NSArray *tableViewItems;


- (void)initParentView;

- (void)actionEditButtonPressed;

- (NSString *)textForCellTextLabelForObject:(NSManagedObject *)object;
- (NSString *)textForCellDetailTextLabelForObject:(NSManagedObject *)object;

- (NSString *)textForFirstLabel;
- (NSString *)textForSecondLabel;
- (NSString *)textForThirdLabel;

- (NSArray *)tableViewItems;

@end
