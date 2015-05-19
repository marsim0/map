//
//  SingleTone.m
//  map
//
//  Created by Мариам Б. on 17.05.15.
//  Copyright (c) 2015 Мариам Б. All rights reserved.
//

#import "SingleTone.h"

@implementation SingleTone

+ (SingleTone *) sharedSingleTone {
    static SingleTone * singleToneObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken , ^ {
    
        singleToneObject = [[self alloc]init];
        
    });
    return singleToneObject;
}

- (void) makeAddressArray {
    
    self.addressArray = [[NSMutableArray alloc] init];
}

@end
