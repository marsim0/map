//
//  MakeAdressList.m
//  map
//
//  Created by Мариам Б. on 14.05.15.
//  Copyright (c) 2015 Мариам Б. All rights reserved.
//

#import "MakeAdressList.h"

@implementation MakeAdressList


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
    
    [self.coordinatesArray insertObject:location atIndex:v.touchNumber];
        
    
}

- (CLLocation*)location : (int) i {
    return [self.coordinatesArray objectAtIndex:i];
}

@end
