//
//  MapPaintSearchView.h
//  BaiduMapApiDemo
//
//  Created by andy on 13-5-30.
//
//

#import <UIKit/UIKit.h>
@class MapPaintSearchView;
@protocol MapPaintSearchDelegate;


@interface MapPaintSearchView : UIView{
    NSMutableArray *array;
    BOOL isTouchEnd;
    BOOL isCircle;
    
    id<MapPaintSearchDelegate> delegate;
    
	CGMutablePathRef linePaths;
    CGPathRef rectPath;
    CGPathRef distanceCirlcePath;
}

@property (retain, nonatomic) NSMutableArray *array;


@property (assign, nonatomic) BOOL isTouchEnd;
@property (assign, nonatomic) BOOL isCircle;

//@property (retain, nonatomic) NSTimer *timer;
@property (atomic, assign) id<MapPaintSearchDelegate> delegate;

-(void) startMapPaintSearch;

+(CGFloat)distanceBetweenPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;

@end


@protocol MapPaintSearchDelegate <NSObject>

-(void) mapPaintSearchImage:(UIImage*)image points:(NSMutableArray *)array isCircle:(BOOL)isCircle;

@end
