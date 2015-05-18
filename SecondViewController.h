//
//  SecondViewController.h
//  map
//
//  Created by Мариам Б. on 17.05.15.
//  Copyright (c) 2015 Мариам Б. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddressTableViewCell.h"
#import "SingleTone.h"

@interface SecondViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource >


@end
