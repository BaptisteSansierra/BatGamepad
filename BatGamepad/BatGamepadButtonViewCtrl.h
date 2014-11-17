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


@class BatGamepadButtonViewCtrl;


@protocol BatGamepadButtonViewCtrlDelegate <NSObject>
@required
- (void)didPushButton:(BatGamepadButtonViewCtrl *)buttonViewCtr withId:(int)index;
@optional
- (void)didReleaseButton:(BatGamepadButtonViewCtrl *)buttonViewCtr withId:(int)index;
@end



@interface BatGamepadButtonViewCtrl : UIViewController
{
    float m_buttonSize;
    BOOL m_isPushed;
    int m_id;
    float m_red, m_green, m_blue;
}

@property(nonatomic, strong) id<BatGamepadButtonViewCtrlDelegate> delegate;

-(id)initWithId:(int)index;
-(id)initWithId:(int)index red:(float)red green:(float)green blue:(float)blue;

+(float)defaultSize;

@end