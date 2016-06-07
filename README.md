# DYLocationConverter

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/DYLocationConverter.svg)](https://img.shields.io/cocoapods/v/DYLocationConverter.svg)
[![Platform](https://img.shields.io/cocoapods/p/DYLocationConverter.svg?style=flat)](http://cocoadocs.org/docsets/DYLocationConverter)
[![Twitter](https://img.shields.io/badge/twitter-@DwarvenYang-blue.svg?style=flat)](http://twitter.com/DwarvenYang)

A location converter between [WGS84](https://wikipedia.org/wiki/WGS84) [GCJ-02](https://en.wikipedia.org/wiki/Restrictions_on_geographic_data_in_China#GCJ-02) and [BD-09](https://en.wikipedia.org/wiki/Restrictions_on_geographic_data_in_China#BD-09).

# Podfile
To integrate DYLocationConverter into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'DYLocationConverter'
```

# How to use 


```obj-c
#import "DYLocationConverter.h"
```

###WGS-84 -> GCJ-02

```obj-c
+ (CLLocationCoordinate2D)gcj02FromWgs84:(CLLocationCoordinate2D)coordinate;
+ (CLLocation *)gcj02LocationFromWgs84:(CLLocation *)location;
```

###GCJ-02 -> WGS-84

```obj-c
+ (CLLocationCoordinate2D)wgs84FromGcj02:(CLLocationCoordinate2D)coordinate;
+ (CLLocation *)wgs84LocationFromGcj02:(CLLocation *)location;
```

###WGS-84 -> BD-09

```obj-c
+ (CLLocationCoordinate2D)bd09FromWgs84:(CLLocationCoordinate2D)coordinate;
+ (CLLocation *)bd09LocationFromWgs84:(CLLocation *)location;
```

###BD-09 -> WGS-84

```obj-c
+ (CLLocationCoordinate2D)wgs84FromBd09:(CLLocationCoordinate2D)coordinate;
+ (CLLocation *)wgs84LocationFromBd09:(CLLocation *)location;
```

###GCJ-02 -> BD-09

```obj-c
+ (CLLocationCoordinate2D)bd09FromGcj02:(CLLocationCoordinate2D)coordinate;
+ (CLLocation *)bd09LocationFromGcj02:(CLLocation *)location;
```

###BD-09 -> GCJ-02

```obj-c
+ (CLLocationCoordinate2D)gcj02FromBd09:(CLLocationCoordinate2D)coordinate;
+ (CLLocation *)gcj02LocationFromBd09:(CLLocation *)location;
```


