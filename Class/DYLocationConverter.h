//
//  DYLocationConverter.h
//  DYLocationConverter
//
//  Created by Dwarven on 16/6/6.
//  Copyright (c) 2016 Dwarven Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DYLocationConverter : NSObject

/**
 *	@brief	世界标准地理坐标(WGS84) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *  ####只在中国大陆的范围的坐标有效，以外直接返回世界标准坐标
 *
 *	@param 	coordinate 	世界标准地理坐标(WGS84)
 *
 *	@return	中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)gcj02FromWgs84:(CLLocationCoordinate2D)coordinate;
+ (CLLocation *)gcj02LocationFromWgs84:(CLLocation *)location;


/**
 *	@brief	中国国测局地理坐标（GCJ-02） 转换成 世界标准地理坐标（WGS84）
 *
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *
 *	@param 	coordinate 	中国国测局地理坐标（GCJ-02）
 *
 *	@return	世界标准地理坐标（WGS84）
 */
+ (CLLocationCoordinate2D)wgs84FromGcj02:(CLLocationCoordinate2D)coordinate;
+ (CLLocation *)wgs84LocationFromGcj02:(CLLocation *)location;


/**
 *	@brief	世界标准地理坐标(WGS84) 转换成 百度地理坐标（BD-09)
 *
 *	@param 	coordinate 	世界标准地理坐标(WGS84)
 *
 *	@return	百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)bd09FromWgs84:(CLLocationCoordinate2D)coordinate;
+ (CLLocation *)bd09LocationFromWgs84:(CLLocation *)location;


/**
 *	@brief	百度地理坐标（BD-09) 转换成 世界标准地理坐标（WGS84）
 *
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *
 *	@param 	coordinate 	百度地理坐标（BD-09)
 *
 *	@return	世界标准地理坐标（WGS84）
 */
+ (CLLocationCoordinate2D)wgs84FromBd09:(CLLocationCoordinate2D)coordinate;
+ (CLLocation *)wgs84LocationFromBd09:(CLLocation *)location;


/**
 *	@brief	中国国测局地理坐标（GCJ-02）<火星坐标> 转换成 百度地理坐标（BD-09)
 *
 *	@param 	coordinate 	中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *	@return	百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)bd09FromGcj02:(CLLocationCoordinate2D)coordinate;
+ (CLLocation *)bd09LocationFromGcj02:(CLLocation *)location;


/**
 *	@brief	百度地理坐标（BD-09) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *	@param 	coordinate 	百度地理坐标（BD-09)
 *
 *	@return	中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)gcj02FromBd09:(CLLocationCoordinate2D)coordinate;
+ (CLLocation *)gcj02LocationFromBd09:(CLLocation *)location;


@end
