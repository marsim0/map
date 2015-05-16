//
//  AddressTableViewCell.h
//  map
//
//  Created by Мариам Б. on 14.05.15.
//  Copyright (c) 2015 Мариам Б. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *ZIP_cellLabel;
@property (strong, nonatomic) IBOutlet UILabel *city_cellLabel;
@property (strong, nonatomic) IBOutlet UILabel *street_cellLabel;

@end
