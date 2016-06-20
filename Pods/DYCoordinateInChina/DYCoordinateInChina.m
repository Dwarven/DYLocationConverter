//
//  DYCoordinateInChina.m
//  https://github.com/Dwarven/DYCoordinateInChina
//
//  Copyright (c) 2016 Dwarven Yang https://github.com/Dwarven
//
//  Created by Dwarven on 16/2/29.
//  Copyright © 2016 Dwarven Yang. All rights reserved.
//

#import "DYCoordinateInChina.h"
#import <MapKit/MapKit.h>

static inline double CLLocationCoordinateNormalizedLatitude(double latitude) {
    return fmod((latitude + 90.0f), 180.0f) - 90.0f;
}

static inline double CLLocationCoordinateNormalizedLongitude(double latitude) {
    return fmod((latitude + 180.0f), 360.0f) - 180.0f;
}

static inline CLLocationCoordinate2D CLLocationCoordinateFromCoordinates(NSArray *coordinates) {
    NSCParameterAssert(coordinates && [coordinates count] >= 2);
    
    NSNumber *longitude = coordinates[0];
    NSNumber *latitude = coordinates[1];
    
    return CLLocationCoordinate2DMake(CLLocationCoordinateNormalizedLatitude([latitude doubleValue]), CLLocationCoordinateNormalizedLongitude([longitude doubleValue]));
}

static inline CLLocationCoordinate2D * CLCreateLocationCoordinatesFromCoordinatePairs(NSArray *coordinatePairs) {
    NSUInteger count = [coordinatePairs count];
    CLLocationCoordinate2D *locationCoordinates = malloc(sizeof(CLLocationCoordinate2D) * count);
    for (NSUInteger idx = 0; idx < count; idx++) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinateFromCoordinates(coordinatePairs[idx]);
        locationCoordinates[idx] = coordinate;
    }
    
    return locationCoordinates;
}

static MKPolygon * MKPolygonFromGeoJSONPolygonFeature(NSDictionary *feature) {
    NSDictionary *geometry = feature[@"geometry"];
    
    NSCParameterAssert([geometry[@"type"] isEqualToString:@"Polygon"]);
    
    NSArray *coordinateSets = geometry[@"coordinates"];
    
    NSMutableArray *mutablePolygons = [NSMutableArray arrayWithCapacity:[coordinateSets count]];
    for (NSArray *coordinatePairs in coordinateSets) {
        CLLocationCoordinate2D *polygonCoordinates = CLCreateLocationCoordinatesFromCoordinatePairs(coordinatePairs);
        MKPolygon *polygon = [MKPolygon polygonWithCoordinates:polygonCoordinates count:[coordinatePairs count]];
        [mutablePolygons addObject:polygon];
        free(polygonCoordinates);
    }
    
    MKPolygon *polygon = nil;
    switch ([mutablePolygons count]) {
        case 0:
            return nil;
        case 1:
            polygon = [mutablePolygons firstObject];
            break;
        default: {
            MKPolygon *exteriorPolygon = [mutablePolygons firstObject];
            NSArray *interiorPolygons = [mutablePolygons subarrayWithRange:NSMakeRange(1, [mutablePolygons count] - 1)];
            polygon = [MKPolygon polygonWithPoints:exteriorPolygon.points count:exteriorPolygon.pointCount interiorPolygons:interiorPolygons];
        }
            break;
    }
    
    NSDictionary *properties = [NSDictionary dictionaryWithDictionary:feature[@"properties"]];
    polygon.title = properties[@"title"];
    polygon.subtitle = properties[@"subtitle"];
    
    return polygon;
}

static id MKShapeFromGeoJSONFeature(NSDictionary *feature) {
    NSCParameterAssert([feature[@"type"] isEqualToString:@"Feature"]);
    
    NSDictionary *geometry = feature[@"geometry"];
    NSString *type = geometry[@"type"];
    if ([type isEqualToString:@"Polygon"]) {
        return MKPolygonFromGeoJSONPolygonFeature(feature);
    }
    
    return nil;
}

static NSArray * MKShapesFromGeoJSONFeatureCollection(NSDictionary *featureCollection) {
    NSCParameterAssert([featureCollection[@"type"] isEqualToString:@"FeatureCollection"]);
    
    NSMutableArray *mutableShapes = [NSMutableArray array];
    for (NSDictionary *feature in featureCollection[@"features"]) {
        id shape = MKShapeFromGeoJSONFeature(feature);
        if (shape) {
            if ([shape isKindOfClass:[NSArray class]]) {
                [mutableShapes addObjectsFromArray:shape];
            } else {
                [mutableShapes addObject:shape];
            }
        }
    }
    
    return [NSArray arrayWithArray:mutableShapes];
}

static DYCoordinateInChina * __sharedInstance = NULL;

@interface DYCoordinateInChina () {
    MKPolygonRenderer * _polygonRenderer;
}

@end

@implementation DYCoordinateInChina

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (__sharedInstance == NULL) {
            __sharedInstance = [[DYCoordinateInChina alloc] init];
        }
    });
    return __sharedInstance;
}

- (id)init{
    self = [super init];
    if (self) {
        NSData *data = [NSData dataWithContentsOfURL:[[NSBundle bundleForClass:[DYCoordinateInChina class]] URLForResource:@"mars_in_china" withExtension:@"geojson"]];
        NSDictionary *geoJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *shapes = MKShapesFromGeoJSONFeatureCollection(geoJSON);
        _polygonRenderer = [[MKPolygonRenderer alloc] initWithPolygon:[shapes firstObject]];
    }
    return self;
}

- (BOOL)coordinateInChina:(CLLocationCoordinate2D)coordinate{
    return CGPathContainsPoint(_polygonRenderer.path, NULL, [_polygonRenderer pointForMapPoint:MKMapPointForCoordinate(coordinate)], FALSE);
}

@end
