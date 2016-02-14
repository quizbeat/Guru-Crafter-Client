//
//  EntityInfoCell.h
//  les41-45(CoreData homework)
//
//  Created by Nikita Makarov on 09/02/16.
//  Copyright © 2016 Nikita Makarov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntityInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *infoTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *infoTextField;

@end
