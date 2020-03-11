//
//  MapPaintSearchView.m
//  BaiduMapApiDemo
//
//  Created by andy on 13-5-30.
//
//

#import "MapPaintSearchView.h"
#import "QuartzCore/QuartzCore.h" 

#define PaintLineWidth 16
#define PaintLineAlpha 0.8

#define PaintAreaWidth 128
#define PaintAreaAlpha 0.3

#define MaxCricleDistance 32

@implementation MapPaintSearchView;

@synthesize array, isTouchEnd, isCircle, delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


-(void)startMapPaintSearch
{
    if (self.array != nil) {
        [self.array removeAllObjects];
    }

    rectPath = CGPathCreateWithRect(self.bounds, nil);
    
    CGRect bounds = CGPathGetBoundingBox(rectPath);
    
    [self setNeedsDisplayInRect:bounds];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesBegan count == %d", [touches count]);
    if(array == nil){
        array = [[NSMutableArray alloc]initWithCapacity:10];
    }else{
        [array removeAllObjects];
    }
    
    isTouchEnd = NO;
    isCircle = NO;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    [array addObject:NSStringFromCGPoint(point)];
    
    
    linePaths = CGPathCreateMutable();
    
    CGRect crilceRect = CGRectMake(point.x - MaxCricleDistance , point.y - MaxCricleDistance, MaxCricleDistance << 1,MaxCricleDistance << 1);
    
    distanceCirlcePath = CGPathCreateWithEllipseInRect(crilceRect, nil);
    
    CGRect bounds = CGPathGetBoundingBox(distanceCirlcePath);

    [self setNeedsDisplayInRect:bounds];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved count == %d", [touches count]);
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [array addObject:NSStringFromCGPoint(point)];
    
    CGPoint previousPoint = [touch previousLocationInView:self];
    
    CGMutablePathRef subpath = CGPathCreateMutable();
    CGPathMoveToPoint(subpath, NULL, previousPoint.x, previousPoint.y);
    CGPathAddLineToPoint(subpath, NULL, point.x, point.y);
    CGRect bounds = CGPathGetBoundingBox(subpath);
	
	CGPathAddPath(linePaths, NULL, subpath);
	CGPathRelease(subpath);
    
    CGRect drawBox = bounds;
    drawBox.origin.x -= PaintLineWidth * 2.0;
    drawBox.origin.y -= PaintLineWidth * 2.0;
    drawBox.size.width += PaintLineWidth * 4.0;
    drawBox.size.height += PaintLineWidth * 4.0;
    
    [self setNeedsDisplayInRect:drawBox];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded count == %d", [touches count]);
    isTouchEnd = YES;
    
    if ([self.array count] > 2) {
        CGPoint startPoint = CGPointFromString([array objectAtIndex:0]);
        CGPoint endPoint = CGPointFromString([array lastObject]);
        
        if ([MapPaintSearchView distanceBetweenPoints:startPoint toPoint:endPoint] <= MaxCricleDistance) {
                isCircle = YES;
            }

        if (rectPath != nil) {
            CGPathRelease(rectPath);
            rectPath = nil;
        }
        if (distanceCirlcePath != nil) {
            CGPathRelease(distanceCirlcePath);
            distanceCirlcePath = nil;
        }        
        
        [self setNeedsDisplay];
        
        UIImage *image = [self getImageFromView];
        
        if (linePaths != nil) {
            CGPathRelease(linePaths);
        }        
        
        [self.delegate mapPaintSearchImage:image points:self.array isCircle:isCircle];
    }
}


-(UIImage *)getImageFromView{
    
    //self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5];
    
    UIGraphicsBeginImageContext(self.bounds.size);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //self.backgroundColor = [UIColor blueColor];

    return image;

}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled count == %d", [touches count]);

}


-(CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    float x = toPoint.x-fromPoint.x;
    float y = toPoint.y-fromPoint.y;
    return sqrt(x * x + y * y);  
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


- (void)drawRect:(CGRect)rect
{
    CGContextRef cgContext = UIGraphicsGetCurrentContext();

    [self printDateWithIndex:1];
    if (rectPath != nil) {
        CGContextSetRGBFillColor(cgContext, 1.0, 1.0, 1.0, 0.0);
        CGContextSetRGBStrokeColor(cgContext, 0, 0.8, 0, 0.6);
        CGContextSetLineWidth(cgContext, 15.0);

        CGContextAddPath(cgContext, rectPath);
        CGContextDrawPath(cgContext, kCGPathFillStroke);
    }
    
    [self printDateWithIndex:2];
    if (array == nil || [array count] < 2) {
        return;
    }
    
    // 线边冒的三种类型
    // CGLineCap. kCGLineCapButt(尖角), kCGLineCapRound(带圆角), kCGLineCapSquare(平角)
    CGContextSetLineCap(cgContext, kCGLineCapRound);
    
    // CGLineJoin. kCGLineJoinMiter(直角), kCGLineJoinRound(圆角), kCGLineJoinBevel(平角)
    CGContextSetLineJoin(cgContext, kCGLineJoinRound);

    if (isTouchEnd) {
        
        if (isCircle) {
            
            for(int i = 0; i <[array count]; i++){
                NSString *str = [array objectAtIndex:i];
                CGPoint p = CGPointFromString(str);
            if (i == 0) {
                    CGContextMoveToPoint(cgContext, p.x, p.y);
                }else{
                    CGContextAddLineToPoint(cgContext, p.x, p.y);
                }
            }
            
            CGContextSetRGBStrokeColor(cgContext, 0.0, 0.8, 0.0, PaintLineAlpha);
            CGContextSetRGBFillColor(cgContext, 0.0, 0.8, 0.0, PaintAreaAlpha);
            CGContextSetLineWidth(cgContext, PaintLineWidth);
            //系统自动完成闭合
            CGContextClosePath(cgContext);
            CGContextDrawPath(cgContext, kCGPathFillStroke);
        }else{
            CGContextAddPath(cgContext, linePaths);
            CGContextSetRGBStrokeColor(cgContext, 0.0, 0.8, 0.0, PaintAreaAlpha);
            CGContextSetLineWidth(cgContext, PaintAreaWidth);
            CGContextStrokePath(cgContext);
            
            CGContextAddPath(cgContext, linePaths);
            CGContextSetRGBStrokeColor(cgContext, 0.0, 0.8, 0.0, PaintLineAlpha);
            CGContextSetLineWidth(cgContext, PaintLineWidth);
            CGContextStrokePath(cgContext);
        }
        
    }else{
        
        [[UIColor clearColor] set];
        UIRectFill(rect);
        
        CGContextAddPath(cgContext, linePaths);
        CGContextSetRGBStrokeColor(cgContext, 0.0, 0.8, 0.0, PaintLineAlpha);
        CGContextSetLineWidth(cgContext, PaintLineWidth);
        
        CGContextStrokePath(cgContext);
    }
    
    
    [self printDateWithIndex:3];
    
    if (distanceCirlcePath != nil) {
        
        CGContextSetRGBFillColor(cgContext, 0.0, 0.8, 0.0, PaintLineAlpha);
        CGContextAddPath(cgContext, distanceCirlcePath);
        CGContextFillPath(cgContext);
    }
    [self printDateWithIndex:4];
}


-(void) printDateWithIndex:(NSInteger) index
{
    //获得系统时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSSS"];  
    NSString *  morelocationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"index === %d printDate === %@", index, morelocationString);
}

- (void)dealloc {
    [self.array release];
    
    [super dealloc];
}



+(CGFloat)distanceBetweenPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    float x = toPoint.x-fromPoint.x;
    float y = toPoint.y-fromPoint.y;
    return sqrt(x * x + y * y);
}


@end
