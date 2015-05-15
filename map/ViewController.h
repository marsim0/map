//
//  ViewController.h
//  map
//
//  Created by Мариам Б. on 13.05.15.
//  Copyright (c) 2015 Мариам Б. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddressTableViewCell.h"
#import "MakeAdressList.h"

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource>

- (IBAction)handleLongPress:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *address_tableView;
- (IBAction)buton_TableView:(id)sender;
@property (assign, nonatomic) NSUInteger touchNumber; //считает количество длинных нажатий

@end

