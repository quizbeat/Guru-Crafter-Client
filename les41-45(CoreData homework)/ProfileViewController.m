//
//  ProfileViewController.m
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 08/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIBarButtonItem *editButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEditButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.object.isDeleted || self.object.managedObjectContext == nil) {
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    
    [self updateLabels];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateLabels
{
    self.firstLabel.text = [self textForFirstLabel];
    self.secondLabel.text = [self textForSecondLabel];
    self.thirdLabel.text = [self textForThirdLabel];
}

- (void)initParentView
{
    UIView *selfView = self.view;
    UIView *nibView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self superclass]) owner:self options:nil] firstObject];
    self.view = selfView;
    for (UIView *view in nibView.subviews) {
        [self.view addSubview:view];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableViewItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ObjectItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    }
    
    NSManagedObject *object = [self.tableViewItems objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [self textForCellTextLabelForObject:object];
    cell.detailTextLabel.text = [self textForCellDetailTextLabelForObject:object];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

@end