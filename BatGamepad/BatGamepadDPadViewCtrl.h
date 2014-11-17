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

#import <UIKit/UIKit.h>

@class BatGamepadDPadViewCtrl;

typedef NS_ENUM(NSInteger, BatGamepadDirection)
{
    BatGamepadNoDirection = 0,
    BatGamepadNorth,
    BatGamepadSouth,
    BatGamepadWest,
    BatGamepadEast,
    BatGamepadNorthWest,
    BatGamepadNorthEast,
    BatGamepadSouthWest,
    BatGamepadSouthEast
};


@protocol BatGamepadDPadViewCtrlDelegate <NSObject>
@required
- (void)padViewCtr:(BatGamepadDPadViewCtrl *)padViewCtr didActiveDPad:(BOOL)active;
@optional
- (void)padViewCtr:(BatGamepadDPadViewCtrl *)padViewCtr didUpdateDirection:(BatGamepadDirection)direction;
- (void)padViewCtr:(BatGamepadDPadViewCtrl *)padViewCtr didUpdateDirectionAngle:(float)angle;
@end



@interface BatGamepadDPadViewCtrl : UIViewController
{
    float m_dPadSize;
    float m_dPadDiscCtrlX;
    float m_dPadDiscCtrlY;
    float m_dPadCircleRad;
    float m_dPadDiscRad;
    float m_dPadDiscCtrlTouchStartX;
    float m_dPadDiscCtrlTouchStartY;
    
    BOOL m_isActive;
    float m_angle;
    BatGamepadDirection m_direction;
    float m_distMinLimit;    // minimum distance for pad activation, must be : 0<=distMinLimit<1
}

-(id)init;
-(id)initWithSize:(float)size;
+(NSString*)directionAsString:(BatGamepadDirection)direction;
+(float)defaultSize;

// Queries
-(BOOL)isActive;
-(BatGamepadDirection) getDPadDirection;
-(float) getDPadAngle;

// Delegate
@property(nonatomic, strong) id<BatGamepadDPadViewCtrlDelegate> delegate;

@end
