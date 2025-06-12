/*
 Copyright (c) 2014 Baptiste Sansierra <support@batsansierra.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.

 */

#import "BatGamepadDPadViewCtrl.h"

#import "UIKit/UIKit.h"


#define SIGN(x) (x<0?-1:1)

@interface BatGamepadDPadViewCtrl ()

@property(strong, nonatomic) UIView *dpadDrawView;
@property(strong, nonatomic) CAShapeLayer *dPadCircleCtrl;
@property(strong, nonatomic) CAShapeLayer *dPadDiscCtrl;

@property(strong, nonatomic) UIPanGestureRecognizer *dPadPanGest;

-(void)dPadPan:(UIPanGestureRecognizer*)sender;

@end



@implementation BatGamepadDPadViewCtrl

@synthesize dpadDrawView;
@synthesize dPadCircleCtrl;
@synthesize dPadDiscCtrl;
@synthesize dPadPanGest;

+(float)defaultSize
{
    return 75.0;
}

-(id)init
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    return [self initWithSize:[BatGamepadDPadViewCtrl defaultSize]];
}

-(id)initWithSize:(float)size
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    // Init vars
    self->m_dPadSize = size;
    self->m_dPadCircleRad = (self->m_dPadSize-2.0)/2.0;
    self->m_dPadDiscRad = 0.55*self->m_dPadSize/2.0;
    self->m_isActive = NO;
    self->m_angle = 0;
    self->m_direction = BatGamepadNoDirection;
    self->m_distMinLimit = 0.333;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dpadDrawView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, m_dPadSize, m_dPadSize)];
    [self.view addSubview:dpadDrawView];
    
    // Draw D-Pad
    float circleLineWidth = 0.75;
    dPadCircleCtrl = [self createBezierCircle:CGPointMake(m_dPadSize/2.0, m_dPadSize/2.0)
                                             radius:m_dPadCircleRad
                                              color:[UIColor colorWithWhite:0.4 alpha:1]
                                          lineWidth:circleLineWidth
                                               fill:NO];
    [dpadDrawView.layer addSublayer:dPadCircleCtrl];
    
    m_dPadDiscCtrlX = m_dPadSize/2.0;
    m_dPadDiscCtrlY = m_dPadSize/2.0;
    dPadDiscCtrl = [self createBezierCircle:CGPointMake(m_dPadDiscCtrlX, m_dPadDiscCtrlY)
                                             radius:m_dPadDiscRad
                                              //color:[UIColor colorWithRed:1.0 green:0.0 blue:0.25 alpha:0.5]
                                              color:[UIColor colorWithWhite:0.5 alpha:1.0]
                                          lineWidth:circleLineWidth
                                               fill:YES];
    dPadDiscCtrl.opacity = 0.5;
    [dpadDrawView.layer addSublayer:dPadDiscCtrl];
    
    // UIGest
    dPadPanGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dPadPan:)];
    dPadPanGest.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:dPadPanGest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)dPadPan:(UIPanGestureRecognizer*)sender
{
    float originX = m_dPadSize/2.0;
    float originY = m_dPadSize/2.0;
    CGPoint origin = CGPointMake(originX, originY);
    float distLimit = m_dPadCircleRad - m_dPadDiscRad;
    
    if( sender.state == UIGestureRecognizerStateBegan  ||  sender.state == UIGestureRecognizerStateChanged  )
    {
        float locx = [sender locationInView:self.view].x;
        float locy = [sender locationInView:self.view].y;
        
        float tx = locx - originX;
        float ty = locy - originY;
        
        CGPoint translate = CGPointMake(tx, ty);
        
        if( !m_isActive )
        {
            float dist = sqrt(tx*tx+ty*ty);
            if( dist<m_distMinLimit*distLimit )
            {
                return;
            }
            m_isActive = YES;
            if( [self.delegate respondsToSelector:@selector(padViewCtr:didActiveDPad:)] )
            {
                [self.delegate padViewCtr:self didActiveDPad:m_isActive];
            }
        }
        //dPadDiscCtrl.fillColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.25 alpha:1].CGColor;
        dPadDiscCtrl.opacity = 1;

        [CATransaction begin];
        [CATransaction setAnimationDuration:0.0];
        //dPadDiscIndic.transform = CATransform3DMakeTranslation(translate.x, translate.y, 0);
        if( circleClampTranslate(origin, &translate, distLimit) )
        {
            //dPadDiscIndic.hidden = NO;
        }
        else
        {
            //dPadDiscIndic.hidden = YES;
        }
        dPadDiscCtrl.transform = CATransform3DMakeTranslation(translate.x, translate.y, 0);
        [CATransaction commit];
        
        m_angle = getDPadAngle(origin, translate);
        m_direction = [self getDPadDirectionFromAngle:m_angle];
        if( [self.delegate respondsToSelector:@selector(padViewCtr:didUpdateDirectionAngle:)] )
        {
            [self.delegate padViewCtr:self didUpdateDirectionAngle:m_angle];
        }
        if( [self.delegate respondsToSelector:@selector(padViewCtr:didUpdateDirection:)] )
        {
            [self.delegate padViewCtr:self didUpdateDirection:m_direction];
        }
    }
    else if( sender.state == UIGestureRecognizerStateEnded )
    {
        //dPadDiscCtrl.fillColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.25 alpha:0.5].CGColor;
        dPadDiscCtrl.opacity = 0.5;

        // Reset position with default interp animation
        dPadDiscCtrl.transform = CATransform3DMakeTranslation(0, 0, 0);        
        
        m_isActive = NO;
        
        if( [self.delegate respondsToSelector:@selector(padViewCtr:didActiveDPad:)] )
        {
            [self.delegate padViewCtr:self didActiveDPad:m_isActive];
        }
    }
}

#pragma mark - Queries

-(BOOL)isActive
{
    return m_isActive;
}

-(BatGamepadDirection) getDPadDirection
{
    return m_direction;
}

-(float) getDPadAngle
{
    return m_angle;
}

-(BatGamepadDirection) getDPadDirectionFromAngle:(float)alpha
{
    if( alpha<=M_PI/8 || alpha>15*M_PI/8 )
    {
        return BatGamepadWest;
    }
    else if( alpha>M_PI/8 && alpha<=3*M_PI/8 )
    {
        return BatGamepadNorthWest;
    }
    else if( alpha>3*M_PI/8 && alpha<=5*M_PI/8 )
    {
        return BatGamepadNorth;
    }
    else if( alpha>5*M_PI/8 && alpha<=7*M_PI/8 )
    {
        return BatGamepadNorthEast;
    }
    else if( alpha>7*M_PI/8 && alpha<=9*M_PI/8 )
    {
        return BatGamepadEast;
    }
    else if( alpha>9*M_PI/8 && alpha<=11*M_PI/8 )
    {
        return BatGamepadSouthEast;
    }
    else if( alpha>11*M_PI/8 && alpha<=13*M_PI/8 )
    {
        return BatGamepadSouth;
    }
    else if( alpha>13*M_PI/8 && alpha<=15*M_PI/8 )
    {
        return BatGamepadSouthWest;
    }
    return BatGamepadNoDirection;
}

+(NSString*)directionAsString:(BatGamepadDirection)direction
{
    if( direction == BatGamepadWest )
    {
        return @"DPadWest";
    }
    else if( direction == BatGamepadNorthWest )
    {
        return @"DPadNorthWest";
    }
    else if( direction == BatGamepadNorth )
    {
        return @"DPadNorth";
    }
    else if( direction == BatGamepadNorthEast )
    {
        return @"DPadNorthEast";
    }
    else if( direction == BatGamepadEast )
    {
        return @"DPadEast";
    }
    else if( direction == BatGamepadSouthEast )
    {
        return @"DPadSouthEast";
    }
    else if( direction == BatGamepadSouth )
    {
        return @"DPadSouth";
    }
    else if( direction == BatGamepadSouthWest )
    {
        return @"DPadSouthWest";
    }
    return @"DPadNoDirection";
}

#pragma mark - Drawing utils

-(CAShapeLayer*) createBezierCircle:(CGPoint)center
                             radius:(float)radius
                              color:(UIColor*)color
                          lineWidth:(float)lineWidth
                               fill:(BOOL)fill
{
    CAShapeLayer *circle = [[CAShapeLayer alloc] init];
    
    circle.path = [UIBezierPath bezierPathWithArcCenter:center
                                                 radius:radius
                                             startAngle:M_PI
                                               endAngle:3*M_PI
                                              clockwise:1].CGPath;
    if( !fill )
    {
        circle.fillColor = [UIColor clearColor].CGColor;
        circle.strokeColor = color.CGColor;
    }
    else
    {
        circle.fillColor = color.CGColor;
        circle.strokeColor = [UIColor clearColor].CGColor;
    }
    circle.lineWidth = lineWidth;
    return circle;
}

bool circleClampTranslate(const CGPoint origin, CGPoint *translate, float limit)
{
    CGPoint dstPoint = CGPointMake(origin.x + translate->x, origin.y + translate->y);
    float dist = sqrt( pow(dstPoint.x-origin.x, 2) + pow(dstPoint.y-origin.y, 2) );
    if( dist<=limit )
    {
        return false;
    }
    
    float alpha = acos(ABS(translate->x) / dist);
    
    float tx = cos(alpha) * limit;
    float ty = sin(alpha) * limit;
    
    translate->x = SIGN(translate->x) * tx;
    translate->y = SIGN(translate->y) * ty;
    
    return true;
}

float getDPadAngle(const CGPoint origin, const CGPoint translate)
{
    CGPoint dstPoint = CGPointMake(origin.x + translate.x, origin.y + translate.y);
    float dist = sqrt( pow(dstPoint.x-origin.x, 2) + pow(dstPoint.y-origin.y, 2) );
    float alpha = acos(ABS(translate.x) / dist);
    
    if( translate.x<0 && translate.y<0 )
    {
        alpha = M_PI - alpha;
    }
    else if( translate.x<0 && translate.y>0 )
    {
        alpha = M_PI + alpha;
    }
    else if( translate.x>0 && translate.y>0 )
    {
        alpha = 2*M_PI - alpha;
    }
    return alpha;
}

@end
