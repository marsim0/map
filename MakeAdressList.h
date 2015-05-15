//
//  MakeAdressList.h
//  map
//
//  Created by Мариам Б. on 14.05.15.
//  Copyright (c) 2015 Мариам Б. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"

@interface MakeAdressList : NSObject 
@property (strong,nonatomic) NSMutableArray * addressArray;
@property (strong,nonatomic) NSMutableArray * coordinatesArray;
@property (strong,nonatomic) NSMutableDictionary * addressDictionary;
//- (void) makeDictionaryOfZIP : (NSString *) zipString City : (NSString *) cityString Street : (NSString *) streetString ;
- (void) makeAddressDictionary;
@property (strong, nonatomic) NSString * stringZIP;
@property (strong, nonatomic) NSString * stringCity;
@property (strong, nonatomic) NSString * stringStreet;
- (void) makeCoordinatesArray : (CLLocation*)location;
- (CLLocation*)location : (int) i;
@end
