//
//  BMKMapPaint.h
//  BaiduMapApiDemo
//
//  Created by andy on 13-6-1.
//
//

#import <Foundation/Foundation.h>
#import "BMKShape.h"
#import "BMKOverlay.h"

@interface BMKMapPaint : BMKShape <BMKOverlay> {
    @package
    CLLocationCoordinate2D coordinate;
    UIImage *image;
}

+ (BMKMapPaint *)mapPaintWithCenterCoordinate:(CLLocationCoordinate2D)aCoord mapRect:(BMKMapRect)mapRect image:(UIImage *)image;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) BMKMapRect boundingMapRect;

@end
