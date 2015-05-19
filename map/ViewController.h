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
#import "SingleTone.h"
#import "SecondViewController.h"

@interface ViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate>


- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender;






@end

