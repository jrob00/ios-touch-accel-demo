//
//  HelloWorldLayer.h
//  AccelTouchesActions
//
//  Created by Jason Roberts on 2/23/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCSprite *ball;
    int tiltHorizontal;
    int tiltVertically;
    int screenWidth;
    int screenHeight;
    
    BOOL areWeTouchingTheScreen;
    int totalTouches;
    int ballLocationX;
    int ballLocationY;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void) scaleUp;
-(void) scaleDown;
-(void) rotateBall;
-(void) resetBallRotation;

@end
