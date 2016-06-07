//
//  DYLocationConverter.m
//  DYLocationConverter
//
//  Created by Dwarven on 16/6/6.
//  Copyright (c) 2016 Dwarven Yang. All rights reserved.
//

#import "DYLocationConverter.h"
#import "DYCoordinateInChina.h"

#define DY_A 6378245.0
#define DY_EE 0.00669342162296594323

@implementation DYLocationConverter

+ (double)transformLat:(double)x bdLon:(double)y {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

+ (double)transformLon:(double)x bdLon:(double)y {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

+ (CLLocationCoordinate2D)gcj02Encrypt:(CLLocationCoordinate2D)coordinate {
    if ([[DYCoordinateInChina sharedInstance] coordinateInChina:coordinate]) {
        CLLocationCoordinate2D resPoint;
        double ggLat = coordinate.latitude;
        double ggLon = coordinate.longitude;
        double dLat = [self transformLat:(ggLon - 105.0) bdLon:(ggLat - 35.0)];
        double dLon = [self transformLon:(ggLon - 105.0) bdLon:(ggLat - 35.0)];
        double radLat = ggLat / 180.0 * M_PI;
        double magic = sin(radLat);
        magic = 1 - DY_EE * magic * magic;
        double sqrtMagic = sqrt(magic);
        dLat = (dLat * 180.0) / ((DY_A * (1 - DY_EE)) / (magic * sqrtMagic) * M_PI);
        dLon = (dLon * 180.0) / (DY_A / sqrtMagic * cos(radLat) * M_PI);
        
        resPoint.latitude = ggLat + dLat;
        resPoint.longitude = ggLon + dLon;
        return resPoint;
    } else {
        return coordinate;
    }
}

+ (CLLocationCoordinate2D)gcj02Decrypt:(CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D  gPt = [self gcj02Encrypt:coordinate];
    double dLat = gPt.latitude - coordinate.latitude;
    double dLon = gPt.longitude - coordinate.longitude;
    CLLocationCoordinate2D pt;
    pt.latitude = coordinate.latitude - dLat;
    pt.longitude = coordinate.longitude - dLon;
    return pt;
}

+ (CLLocationCoordinate2D)bd09Decrypt:(CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D gcjPt;
    double x = coordinate.longitude - 0.0065, y = coordinate.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) - 0.000003 * cos(x * M_PI);
    gcjPt.longitude = z * cos(theta);
    gcjPt.latitude = z * sin(theta);
    return gcjPt;
}

+(CLLocationCoordinate2D)bd09Encrypt:(CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D bdPt;
    double x = coordinate.longitude, y = coordinate.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) + 0.000003 * cos(x * M_PI);
    bdPt.longitude = z * cos(theta) + 0.0065;
    bdPt.latitude = z * sin(theta) + 0.006;
    return bdPt;
}

#pragma mark - gcj02FromWgs84
+ (CLLocationCoordinate2D)gcj02FromWgs84:(CLLocationCoordinate2D)coordinate {
    return [self gcj02Encrypt:coordinate];
}

+ (CLLocation *)gcj02LocationFromWgs84:(CLLocation *)location {
    CLLocationCoordinate2D coordinate = [self gcj02FromWgs84:location.coordinate];
    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

#pragma mark - wgs84FromGcj02
+ (CLLocationCoordinate2D)wgs84FromGcj02:(CLLocationCoordinate2D)coordinate {
    return [self gcj02Decrypt:coordinate];
}

+ (CLLocation *)wgs84LocationFromGcj02:(CLLocation *)location {
    CLLocationCoordinate2D coordinate = [self wgs84FromGcj02:location.coordinate];
    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

#pragma mark - bd09FromWgs84
+ (CLLocationCoordinate2D)bd09FromWgs84:(CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D gcj02Pt = [self gcj02Encrypt:coordinate];
    return [self bd09Encrypt:gcj02Pt] ;
}

+ (CLLocation *)bd09LocationFromWgs84:(CLLocation *)location {
    CLLocationCoordinate2D coordinate = [self bd09FromWgs84:location.coordinate];
    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

#pragma mark - wgs84FromBd09
+ (CLLocationCoordinate2D)wgs84FromBd09:(CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D gcj02 = [self gcj02FromBd09:coordinate];
    return [self gcj02Decrypt:gcj02];
}

+ (CLLocation *)wgs84LocationFromBd09:(CLLocation *)location {
    CLLocationCoordinate2D coordinate = [self wgs84FromBd09:location.coordinate];
    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

#pragma mark - bd09FromGcj02
+ (CLLocationCoordinate2D)bd09FromGcj02:(CLLocationCoordinate2D)coordinate {
    return  [self bd09Encrypt:coordinate];
}

+ (CLLocation *)bd09LocationFromGcj02:(CLLocation *)location {
    CLLocationCoordinate2D coordinate = [self bd09FromGcj02:location.coordinate];
    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

#pragma mark - gcj02FromBd09
+ (CLLocationCoordinate2D)gcj02FromBd09:(CLLocationCoordinate2D)coordinate {
    return [self bd09Decrypt:coordinate];
}

+ (CLLocation *)gcj02LocationFromBd09:(CLLocation *)location {
    CLLocationCoordinate2D coordinate = [self gcj02FromBd09:location.coordinate];
    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

@end
