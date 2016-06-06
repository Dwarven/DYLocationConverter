//
//  DYCoordinateInChina.h
//  https://github.com/Dwarven/DYCoordinateInChina
//
//  Copyright (c) 2016 Dwarven Yang https://github.com/Dwarven
//
//  Created by Dwarven on 16/2/29.
//  Copyright © 2016 Dwarven Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface DYCoordinateInChina : NSObject

+ (instancetype)sharedInstance;

- (BOOL)coordinateInChina:(CLLocationCoordinate2D)coordinate;

@end
