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

#import "BatGamepadExample.h"

#import "BatGamepad.h"
#import "BatGamepadDPadViewCtrl.h"
#import "BatGamepadButtonViewCtrl.h"

#define kMaxIdleTimeSeconds 60.0
#define SIGN(x) (x<0?-1:1)


@interface BatGamepadExample () <BatGamepadDPadViewCtrlDelegate, BatGamepadButtonViewCtrlDelegate>
@property(nonatomic, strong) UILabel* title;

@property(nonatomic, strong) UIView* gameView;
@property(nonatomic, strong) BatGamepad *gamepad;
@property(nonatomic, strong) CAShapeLayer *spaceshipLayer;

@end

@implementation BatGamepadExample

@synthesize gamepad;
@synthesize spaceshipLayer;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    CGSize mainSize = [self.view bounds].size;

    // UI Controllers
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, mainSize.width, 30)];
    self.title.text = @"My Game";
    self.title.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.title];
    
    // Game view
    CGSize gameSize = CGSizeMake(mainSize.width, mainSize.height-130);
    CGRect gameViewRect = CGRectMake(0, 130, gameSize.width, gameSize.height);
    self.gameView = [[UIView alloc] initWithFrame:gameViewRect];
    self.gameView.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1];
    self.gameView.clipsToBounds = YES;
    [self.view addSubview:self.gameView];

    // Add spaceshipLayer
    spaceshipLayer = [[CAShapeLayer alloc] init];
    float charSize = 10;
    float charWidth = 3*charSize;
    float charMidHeight = charSize;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, -0.5*charWidth, charMidHeight);
    CGPathAddLineToPoint(path, nil, 0.5*charWidth, 0);
    CGPathAddLineToPoint(path, nil, -0.5*charWidth, -charMidHeight);
    CGPathAddLineToPoint(path, nil, -0.5*charWidth, charMidHeight);
    spaceshipLayer.path = path;
    spaceshipLayer.lineWidth = 1;
    spaceshipLayer.strokeColor = [UIColor whiteColor].CGColor;
    spaceshipLayer.position = CGPointMake( gameSize.width/2.0,
                                           gameSize.height/2.0 );
    
    [self.gameView.layer addSublayer:spaceshipLayer];

    // Game controller
    gamepad = [[BatGamepad alloc] initWithControllers:(BAT_GAMEPAD_DPAD_BIT |
                                                       BAT_GAMEPAD_BUTTON1_BIT |
                                                       BAT_GAMEPAD_BUTTON2_BIT |
                                                       BAT_GAMEPAD_BUTTON3_BIT |
                                                       BAT_GAMEPAD_BUTTON4_BIT )
                                              forView:self.gameView
                                    forViewController:self
                                             delegate:self];

    // Init 'Physics'
    m_spaceShipSpeed = CGPointMake(0, 0);
    m_spaceShipAccel = 1.2;
    m_spaceShipFriction = 0.03;
    m_spaceShipSpeedLimit = 100;
    m_spaceShipSpeedEpsilon = 0.1;
    
    // Init timer
    m_idleTimer = [NSTimer scheduledTimerWithTimeInterval:0.041
                                                   target:self
                                                 selector:@selector(idleFunc)
                                                 userInfo:nil
                                                  repeats:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - BatGameDPadViewCtrlDelegate

- (void)padViewCtr:(BatGamepadDPadViewCtrl *)padViewCtr didActiveDPad:(BOOL)active
{
    m_isActiveDpad = active;
}

- (void)padViewCtr:(BatGamepadDPadViewCtrl *)padViewCtr didUpdateDirectionAngle:(float)angle
{
    m_dpadAngle = angle;
}

#pragma mark - BatGameButtonPadViewCtrlDelegate

- (void)didPushButton:(BatGamepadButtonViewCtrl *)buttonViewCtr withId:(int)index
{
    if(index==1)
    {
        spaceshipLayer.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor;
    }
}



#pragma mark Handling idle

-(void)idleFunc
{
    // Apply friction
    float speedX = m_spaceShipSpeed.x;
    float speedY = m_spaceShipSpeed.y;
    if( speedX || speedY )
    {
        speedX *= 1-m_spaceShipFriction;
        speedY *= 1-m_spaceShipFriction;
        float speed = sqrt(speedX*speedX+speedY*speedY);
        if( speed < m_spaceShipSpeedEpsilon )
        {
            speedX = 0;
            speedY = 0;
        }
        m_spaceShipSpeed = CGPointMake(speedX, speedY);
    }
    // Increase spaceship speed
    if( m_isActiveDpad )
    {
        m_spaceShipAngle = -m_dpadAngle;
        float speedX = cos(m_spaceShipAngle) * m_spaceShipAccel + m_spaceShipSpeed.x;
        float speedY = sin(m_spaceShipAngle) * m_spaceShipAccel + m_spaceShipSpeed.y;
        speedX = speedX>m_spaceShipSpeedLimit ? m_spaceShipSpeedLimit : speedX;
        speedY = speedY>m_spaceShipSpeedLimit ? m_spaceShipSpeedLimit : speedY;
        m_spaceShipSpeed = CGPointMake(speedX, speedY);
    }
    // Update spaceship position
    if( m_spaceShipSpeed.x || m_spaceShipSpeed.y )
    {        
        CGPoint currentPos = spaceshipLayer.position;
        float px = currentPos.x + m_spaceShipSpeed.x;
        float py = currentPos.y + m_spaceShipSpeed.y;
        CGSize screenSize = [self.gameView bounds].size;
        if(px<0)
        {
            px = screenSize.width;
        }
        else if(px>screenSize.width)
        {
            px = 0;
        }

        if(py<0)
        {
            py = screenSize.height;
        }
        else if(py>screenSize.height)
        {
            py = 0;
        }
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DRotate(transform, m_spaceShipAngle, 0, 0, 1);
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.0];
        spaceshipLayer.position = CGPointMake(px, py);
        spaceshipLayer.transform = transform;
        [CATransaction commit];
    }
}

@end
