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

#import "BatGamepadButtonViewCtrl.h"
#import "BatGamepadDrawHelpers.h"

@interface BatGamepadButtonViewCtrl ()

@property(strong, nonatomic) CAShapeLayer *discCtrl;
@property(strong, nonatomic) CAShapeLayer *circleCtrl;

@end



@implementation BatGamepadButtonViewCtrl

@synthesize delegate;
@synthesize discCtrl;
@synthesize circleCtrl;

+(float)defaultSize
{
    return 35.0;
}


-(id)initWithId:(int)index
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    return [self initWithId:index red:1 green:0 blue:0];
}

-(id)initWithId:(int)index red:(float)red green:(float)green blue:(float)blue
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    return [self initWithId:index size:[BatGamepadButtonViewCtrl defaultSize] red:red green:green blue:blue];
}

-(id)initWithId:(int)index size:(float)size red:(float)red green:(float)green blue:(float)blue
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    
    // Init vars
    self->m_buttonSize = size;
    self->m_isPushed = NO;
    self->m_id = index;
    self->m_red = red;
    self->m_green = green;
    self->m_blue = blue;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create graphics
    discCtrl = createBezierCircle( CGPointMake(m_buttonSize/2.0, m_buttonSize/2.0),
                                   m_buttonSize/2.0,
                                   [UIColor colorWithRed:m_red green:m_green blue:m_blue alpha:1],
                                   1, // width
                                   YES // fill
                                  );
    discCtrl.opacity = 0.5;
    [self.view.layer addSublayer:discCtrl];
    
    circleCtrl = createBezierCircle( CGPointMake(m_buttonSize/2.0, m_buttonSize/2.0),
                                     m_buttonSize/2.0,
                                     [UIColor colorWithWhite:0.4 alpha:1],
                                     1, // width
                                     NO // fill
                                    );
    [self.view.layer addSublayer:circleCtrl];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    m_isPushed = YES;
    //discCtrl.fillColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.25 alpha:1].CGColor;
    discCtrl.opacity = 1;
    circleCtrl.hidden = YES;
    if( [delegate respondsToSelector:@selector(didPushButton:withId:)] )
    {
        [delegate didPushButton:self withId:m_id];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    m_isPushed = NO;
    //discCtrl.fillColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.25 alpha:0.5].CGColor;
    discCtrl.opacity = 0.5;
    circleCtrl.hidden = NO;
    if( [delegate respondsToSelector:@selector(didReleaseButton:withId:)] )
    {
        [delegate didReleaseButton:self withId:m_id];
    }
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{    
    m_isPushed = NO;
    //discCtrl.fillColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.25 alpha:0.5].CGColor;
    discCtrl.opacity = 0.5;
    circleCtrl.hidden = NO;
    if( [delegate respondsToSelector:@selector(didReleaseButton:withId:)] )
    {
        [delegate didReleaseButton:self withId:m_id];
    }
}

@end
