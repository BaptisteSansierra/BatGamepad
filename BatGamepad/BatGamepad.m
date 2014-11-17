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

#import "BatGamepad.h"



@interface BatGamepad()

@property(nonatomic,strong) BatGamepadDPadViewCtrl* dpad;
@property(nonatomic,strong) BatGamepadButtonViewCtrl* button1;
@property(nonatomic,strong) BatGamepadButtonViewCtrl* button2;
@property(nonatomic,strong) BatGamepadButtonViewCtrl* button3;
@property(nonatomic,strong) BatGamepadButtonViewCtrl* button4;

@end



@implementation BatGamepad

@synthesize dpad;
@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;

-(id)initWithControllers:(int)flags
                 forView:(UIView*)view
       forViewController:(UIViewController*)viewCtr
                delegate:(id<BatGamepadDPadViewCtrlDelegate,BatGamepadButtonViewCtrlDelegate>)delegate
{
    self = [super init];
    if( !self )
    {
        return nil;
    }
    
    if( flags & BAT_GAMEPAD_DPAD_BIT )
    {
        float dpadSize = [BatGamepadDPadViewCtrl defaultSize];
        float dpadMargin = 35;
        dpad = [[BatGamepadDPadViewCtrl alloc] init];
        dpad.delegate = delegate;
        dpad.view.frame = CGRectMake(dpadMargin,
                                     [view bounds].size.height-dpadSize-dpadMargin,
                                     dpadSize,
                                     dpadSize);
        if(viewCtr)
        {
            [viewCtr addChildViewController:dpad];
        }
        [view addSubview:dpad.view];
        
    }
    float buttSize = [BatGamepadButtonViewCtrl defaultSize];
    
    float buttBorderMargin = 40;
    float buttHorizSpacing = 45;
    float buttVertSpacing = buttSize;
    
    CGSize parentSize = [view bounds].size;
    float b1x = parentSize.width - buttSize - buttBorderMargin;
    float b1y = parentSize.height - 2*buttSize - buttBorderMargin;
    
    float b2x = b1x - buttHorizSpacing;
    float b2y = b1y + buttVertSpacing;
    
    float b3x = b2x;
    float b3y = b1y - buttVertSpacing;
    
    float b4x = b2x - buttHorizSpacing;
    float b4y = b1y;
    
    if( flags & BAT_GAMEPAD_BUTTON1_BIT )
    {
        button1 = [[BatGamepadButtonViewCtrl alloc] initWithId:1];
        button1.delegate = delegate;
        button1.view.frame = CGRectMake(b1x,
                                        b1y,
                                        buttSize,
                                        buttSize);
        if(viewCtr)
        {
            [viewCtr addChildViewController:button1];
        }
        [view addSubview:button1.view];
    }
    if( flags & BAT_GAMEPAD_BUTTON2_BIT )
    {
        button2 = [[BatGamepadButtonViewCtrl alloc] initWithId:2 red:1 green:1 blue:0];
        button2.delegate = delegate;
        button2.view.frame = CGRectMake(b2x,
                                        b2y,
                                        buttSize,
                                        buttSize);
        if(viewCtr)
        {
            [viewCtr addChildViewController:button2];
        }
        [view addSubview:button2.view];
    }
    if( flags & BAT_GAMEPAD_BUTTON3_BIT )
    {
        button3 = [[BatGamepadButtonViewCtrl alloc] initWithId:3 red:0 green:0 blue:1];
        button3.delegate = delegate;
        button3.view.frame = CGRectMake(b3x,
                                        b3y,
                                        buttSize,
                                        buttSize);
        if(viewCtr)
        {
            [viewCtr addChildViewController:button3];
        }
        [view addSubview:button3.view];
    }
    if( flags & BAT_GAMEPAD_BUTTON4_BIT )
    {
        button4 = [[BatGamepadButtonViewCtrl alloc] initWithId:4 red:0 green:1 blue:0];
        button4.delegate = delegate;
        button4.view.frame = CGRectMake(b4x,
                                        b4y,
                                        buttSize,
                                        buttSize);
        if(viewCtr)
        {
            [viewCtr addChildViewController:button4];
        }
        [view addSubview:button4.view];
    }
    
    
    
    return self;
}

@end
