//
//  HelloWorldLayer.m
//  AccelTouchesActions
//
//  Created by Jason Roberts on 2/23/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        // get our window size
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        screenWidth = size.width;
        screenHeight = size.height;
		
        // create our sprite
        ball = [CCSprite spriteWithFile:@"graham.png"];
        [self addChild:ball ];
        ball.position = CGPointMake( screenWidth / 2, screenHeight / 2);
        ball.scale = .5;
        
        self.isTouchEnabled = YES;
        self.isAccelerometerEnabled = YES;
        
        [self schedule:@selector(updateBall:) interval: 1.0f/60.0f];
        
	}
	return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    areWeTouchingTheScreen = YES;
    
    // convert touch coordinates to x and y
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    ballLocationX = location.x;
    ballLocationY = location.y;
    
    // increase the scale of our ball
    [self scaleUp];
    
    // rotate the ball
    [self rotateBall];
    
    totalTouches = 1;
}


/* don't forget to add these lines to your AppDelegate.m file...
// turn on multiple touches
EAGLView *view = [director openGLView];
[view setMultipleTouchEnabled:YES];
*/

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    areWeTouchingTheScreen = YES;
    
    // detecting two touches
    NSArray *touchArray = [touches allObjects];
    
    if ([touchArray count] > 1) {
        
        totalTouches = 2;
        
        UITouch *fingerOne = [touchArray objectAtIndex:0];
        UITouch *fingerTwo = [touchArray objectAtIndex:1];
        
        CGPoint pointOne = [fingerOne locationInView:[fingerOne view]];
        CGPoint pointTwo = [fingerTwo locationInView:[fingerTwo view]];
        
        pointOne = [[CCDirector sharedDirector] convertToGL:pointOne]; // pointOne.x, pointOne.y
        pointTwo = [[CCDirector sharedDirector] convertToGL:pointTwo];
        
        ballLocationX = pointOne.x - ((pointOne.x - pointTwo.x)/2);
        ballLocationY = pointOne.y - ((pointOne.y - pointTwo.y)/2);
        
        //ball.position = ccp( pointOne.x - ((pointOne.x - pointTwo.x)/2), pointOne.y - ((pointOne.y - pointTwo.y)/2) );
        
    } else if (totalTouches == 1) {
                
        // convert touch coordinates to x and y
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        ballLocationX = location.x;
        ballLocationY = location.y;
        
        //ball.position = ccp( location.x, location.y );
        
    }
    
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    totalTouches--;
    //CCLOG(@"touches ended, (totalTouches: %i)", totalTouches);
    
    if (totalTouches == 0) {
        
        areWeTouchingTheScreen = NO;
        
    }/* else if (totalTouches == 1) {
        
        // convert touch coordinates to x and y
        UITouch *touch = [touches anyObject];
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        
        ballLocationX = location.x;
        ballLocationY = location.y;
        
    }*/
    
    // decrease the scale of our ball
    [self scaleDown];
    
    [self resetBallRotation];
}


-(void) scaleUp {
    
    CCAction* upAction = [CCScaleTo actionWithDuration:2.0f scale:2.0f];
    upAction.tag = 99;
    [ball runAction:upAction];
    
}

-(void) scaleDown {
    
    [ball stopActionByTag:99]; // this isn't actually necessary.. i'm not sure why
    
    CCAction* downAction = [CCScaleTo actionWithDuration:2.0f scale:0.5f];
    [ball runAction:downAction];
    
}

-(void) rotateBall {
    
    CCRotateBy* rotateBall = [CCRotateBy actionWithDuration:4.0f angle:360];
    rotateBall.tag = 66;
    
    //CCRepeatForever* repeatRotate = [CCRepeatForever actionWithAction:rotateBall];
    [ball runAction:rotateBall];
    
}

-(void) resetBallRotation {
    
    [ball stopActionByTag:66];
        
    CCRotateTo* rotateBall = [CCRotateTo actionWithDuration:2.0f angle:0];
    [ball runAction:rotateBall];
    
}

- (void) updateBall:(ccTime) delta {
    
    if (areWeTouchingTheScreen == NO) {
        
        // x axis
        
        if (ball.position.x >= 0 && ball.position.x <= screenWidth) {
            
            ball.position = ccp( ball.position.x + tiltHorizontal, ball.position.y );
            
        } else if (ball.position.x < 0) {
            
            ball.position = ccp( 0, ball.position.y );
            
        } else if (ball.position.x > screenWidth) {
            
            ball.position = ccp( screenWidth, ball.position.y );
            
        }
        
        // y axis
        
        if (ball.position.y >= 0 && ball.position.y <= screenHeight) {
            
            ball.position = ccp( ball.position.x, ball.position.y + tiltVertically);
            
        } else if (ball.position.y < 0) {
            
            ball.position = ccp( ball.position.x, 0 );
            
        } else if (ball.position.y > screenHeight) {
            
            ball.position = ccp( ball.position.x, screenHeight );
            
        }
        
    } else {
        
        // animate toward the touch coordinates
        //CCLOG(@"totaltouches: %i", totalTouches);
        
        ball.position = ccp( ball.position.x + ((ballLocationX - ball.position.x) / 10), ball.position.y + ((ballLocationY - ball.position.y) / 10) );
        
    }
}


- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    //CCLOG(@"acceleration values are, x:%f y:%f z:%f", acceleration.x, acceleration.y, acceleration.z);
    
    tiltHorizontal = acceleration.y * -20;
    tiltVertically = acceleration.x * 20;
    
    //CCLOG(@"tiltHorizontal is: %i", tiltHorizontal);
    
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
