//
//  MakeAdressList.m
//  map
//
//  Created by Мариам Б. on 14.05.15.
//  Copyright (c) 2015 Мариам Б. All rights reserved.
//

#import "MakeAdressList.h"

@implementation MakeAdressList

//- (void) makeDictionaryOfZIP : (NSString *) zipString City : (NSString *) cityString Street : (NSString *) streetString  {
//    
//    self.addressArray = [[NSMutableArray alloc]init];
//    self.addressDictionary = [[NSMutableDictionary alloc]init];
//    
//    for (int i = 0; i <= self.addressDictionary.count; i++) {
//        [self.addressDictionary setObject: zipString forKey:@"ZIP"];
//        [self.addressDictionary setObject: cityString forKey:@"City"];
//        [self.addressDictionary setObject: streetString forKey:@"Street"];
//        
//        [self.addressArray addObject:self.addressDictionary];
//    }
//}

- (void) makeAddressDictionary  {
    
    self.addressArray = [[NSMutableArray alloc]init];
    self.addressDictionary = [[NSMutableDictionary alloc]init];
    ViewController * v = [[ViewController alloc]init];
    
    [self.addressDictionary setObject: self.stringZIP forKey:@"ZIP"];
    [self.addressDictionary setObject: self.stringCity forKey:@"City"];
    [self.addressDictionary setObject: self.stringStreet forKey:@"Street"];    
    
    [self.addressArray insertObject:self.addressDictionary atIndex:v.touchNumber];
    
}


- (void) makeCoordinatesArray : (CLLocation*)location {
    self.coordinatesArray = [[NSMutableArray alloc] init];
    ViewController * v = [[ViewController alloc]init];
    for (int i = 0; i < v.touchNumber+1; i++) {
        [self.coordinatesArray setObject:location atIndexedSubscript:i];
        
    };
}

- (CLLocation*)location : (int) i {
    return [self.coordinatesArray objectAtIndex:i];
}

@end
