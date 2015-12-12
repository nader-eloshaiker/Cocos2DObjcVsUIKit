//
//  HelloWorldScene.m
//
//  Created by : Nader Eloshaiker
//  Project    : CALayerRendering
//  Date       : 30/11/2015
//
//  Copyright (c) 2015 Nader Eloshaiker.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "HelloWorldScene.h"


#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define DURATION_START_DELAY 2.0
#define DURATION_PAUSE_DELAY 1.0
#define DURATION_ANIMATE 10.0


// -----------------------------------------------------------------------

@implementation HelloWorldScene

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    
    // The thing is, that if this fails, your app will 99.99% crash anyways, so why bother
    // Just make an assert, so that you can catch it in debug
    NSAssert(self, @"Whoops");
    
    // Background
    CCSprite9Slice *background = [CCSprite9Slice spriteWithImageNamed:@"white_square.png"];
    background.anchorPoint = CGPointZero;
    background.contentSize = [CCDirector sharedDirector].viewSize;
    background.color = [CCColor darkGrayColor];
    [self addChild:background];
    
    // The standard Hello World text
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"ArialMT" fontSize:64];
    label.positionType = CCPositionTypeNormalized;
    label.position = (CGPoint){0.5, 0.5};
    [self addChild:label];
    
    CCTime stdDelay = DURATION_ANIMATE*2 + DURATION_START_DELAY + DURATION_PAUSE_DELAY;
    
    [self renderUIViews];
    [self runAction:[CCActionSequence actionOne:[CCActionDelay actionWithDuration:stdDelay]   two:[CCActionCallFunc actionWithTarget:self selector:@selector(renderCCNodes)]]];
    [self runAction:[CCActionSequence actionOne:[CCActionDelay actionWithDuration:stdDelay*2] two:[CCActionCallFunc actionWithTarget:self selector:@selector(renderUILabels)]]];
    [self runAction:[CCActionSequence actionOne:[CCActionDelay actionWithDuration:stdDelay*3] two:[CCActionCallFunc actionWithTarget:self selector:@selector(renderCCLabels)]]];
    
    // done
    return self;
}

-(void)renderCCNodes {
    CGSize labelSize = CGSizeMake(50, 50);
    CGSize scrnSize = [[CCDirector sharedDirector] viewSize];
    
    
    for (int i=0; i<1000; i++) {
        CCNodeColor *node = [CCNodeColor nodeWithColor:[CCColor colorWithUIColor:[self getRandomColor]]];
        CGRect rect = [self getRandomFrame:scrnSize size:labelSize];
        node.position = rect.origin;
        node.contentSize = rect.size;
        [self addChild:node];
        
        
        id rotate1 = [CCActionRotateTo actionWithDuration:DURATION_ANIMATE angle:[self getRandomRotation]];
        id scale1 = [CCActionScaleTo actionWithDuration:DURATION_ANIMATE scaleX:[self getRandomScale] scaleY:[self getRandomScale]];
        id tint1 = [CCActionTintTo actionWithDuration:DURATION_ANIMATE color:[CCColor colorWithUIColor:[self getRandomColor]]];
        id position1 = [CCActionMoveTo actionWithDuration:DURATION_ANIMATE position:[self getRandomPoint:scrnSize]];
        id action1 = [CCActionSpawn actions:rotate1, scale1, tint1, position1, nil];
        action1 = [CCActionEaseBounceOut actionWithAction:action1];
        
        
        id rotate2 = [CCActionRotateTo actionWithDuration:DURATION_ANIMATE angle:[self getRandomRotation]];
        id scale2 = [CCActionScaleTo actionWithDuration:DURATION_ANIMATE scaleX:[self getRandomScale] scaleY:[self getRandomScale]];
        id tint2 = [CCActionTintTo actionWithDuration:DURATION_ANIMATE color:[CCColor colorWithUIColor:[self getRandomColor]]];
        id position2 = [CCActionMoveTo actionWithDuration:DURATION_ANIMATE position:[self getRandomPoint:scrnSize]];
        id action2 = [CCActionSpawn actions:rotate2, scale2, tint2, position2, nil];
        action2 = [CCActionEaseElasticOut actionWithAction:action2];
        
        id remove = [CCActionRemove action];
        
        id delayStart = [CCActionDelay actionWithDuration:DURATION_START_DELAY];
        id delayPause = [CCActionDelay actionWithDuration:DURATION_PAUSE_DELAY];
        
        [node runAction:[CCActionSequence actions:delayStart, action1, delayPause, action2, remove, nil]];
    }
}

-(void)renderUIViews {
    UIView *view = [[CCDirector sharedDirector] view];
    CGSize scrnSize = [[CCDirector sharedDirector] viewSize];
    CGSize labelSize = CGSizeMake(50, 50);
    
    for (int i=0; i<500; i++) {
        UIView *subView = [[UIView alloc] initWithFrame:[self getRandomFrame:scrnSize size:labelSize]];
        subView.backgroundColor = [self getRandomColor];
        [view addSubview:subView];
        
        [UIView animateWithDuration:DURATION_ANIMATE
                              delay:DURATION_START_DELAY
                            options: UIViewAnimationCurveEaseOut+UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             CGAffineTransform transform = CGAffineTransformIdentity;
                             transform = CGAffineTransformScale(transform, [self getRandomScale], [self getRandomScale]);
                             transform = CGAffineTransformRotate(transform, [self getRandomRotationRad]);
                             subView.frame = [self getRandomFrame:scrnSize size:labelSize];
                             subView.backgroundColor = [self getRandomColor];
                             subView.transform = transform;
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:DURATION_ANIMATE
                                                   delay:DURATION_PAUSE_DELAY
                                                 options: UIViewAnimationCurveEaseOut+UIViewAnimationOptionBeginFromCurrentState
                                              animations:^{
                                                  CGAffineTransform transform = CGAffineTransformIdentity;
                                                  transform = CGAffineTransformScale(transform, [self getRandomScale], [self getRandomScale]);
                                                  transform = CGAffineTransformRotate(transform, [self getRandomRotationRad]);
                                                  subView.frame = [self getRandomFrame:scrnSize size:labelSize];
                                                  subView.backgroundColor = [self getRandomColor];
                                                  subView.transform = transform;
                                              }
                                              completion:^(BOOL finished) {
                                                  [subView removeFromSuperview];
                                              }];
                         }];
        
    }
}

-(void)renderCCLabels {
    CGSize scrnSize = [[CCDirector sharedDirector] viewSize];


    for (int i=0; i<1000; i++) {
        NSString *str = [NSString stringWithFormat:@"Odecee:%0.2f", [self getRandomRotation]];
        CCLabelTTF *label = [CCLabelTTF labelWithString:str fontName:@"ArialMT" fontSize:16];
        label.color = [CCColor colorWithUIColor:[self getRandomColor]];
        label.position = [self getRandomPoint:scrnSize];
        label.visible = false;
        [self addChild:label];
        
        id rotate1 = [CCActionRotateTo actionWithDuration:DURATION_ANIMATE angle:[self getRandomRotation]];
        id scale1 = [CCActionScaleTo actionWithDuration:DURATION_ANIMATE scale:[self getRandomScale]];
        id tint1 = [CCActionTintTo actionWithDuration:DURATION_ANIMATE color:[CCColor colorWithUIColor:[self getRandomColor]]];
        id position1 = [CCActionMoveTo actionWithDuration:DURATION_ANIMATE position:[self getRandomPoint:scrnSize]];
        id action1 = [CCActionSpawn actions:rotate1, scale1, tint1, position1, nil];
        action1 = [CCActionEaseBounceOut actionWithAction:action1];
        

        id show = [CCActionShow action];
        id remove = [CCActionRemove action];

        id delayStart = [CCActionDelay actionWithDuration:DURATION_START_DELAY];
        id delayPause = [CCActionDelay actionWithDuration:DURATION_PAUSE_DELAY];

        [label runAction:[CCActionSequence actions:show, delayStart, action1, delayPause, remove, nil]];
    }
}

-(void)renderUILabels {
    UIView *view = [[CCDirector sharedDirector] view];
    CGSize scrnSize = [[CCDirector sharedDirector] viewSize];
    CGSize labelSize = CGSizeMake(50, 50);
    
    
    for (int i=0; i<1000; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:[self getRandomFrame:scrnSize size:labelSize]];
        label.textColor = [self getRandomColor];
        label.numberOfLines = 1;
        label.text = [NSString stringWithFormat:@"Odecee:%0.2f", [self getRandomRotation]];
        label.font = [UIFont fontWithName:@"ArialMT" size:16.0];
        [view addSubview:label];
        
        [UILabel animateWithDuration:DURATION_ANIMATE
                               delay:DURATION_START_DELAY
                             options: UIViewAnimationCurveEaseOut+UIViewAnimationOptionBeginFromCurrentState
                          animations:^{
                              CGAffineTransform transform = CGAffineTransformIdentity;
                              transform = CGAffineTransformScale(transform, [self getRandomScale], [self getRandomScale]);
                              transform = CGAffineTransformRotate(transform, [self getRandomRotationRad]);
                              label.frame = [self getRandomFrame:scrnSize size:labelSize];
                              label.transform = transform;
                          }
                          completion:^(BOOL finished){
                              [label removeFromSuperview];
                          }];
    }
}

-(UIColor*)getRandomColor {
    CGFloat red = arc4random_uniform(255);
    red /= 255.0;
    CGFloat green = arc4random_uniform(255);
    green /= 255.0;
    CGFloat blue = arc4random_uniform(255);
    blue /= 255.0;
    CGFloat alpha = arc4random_uniform(127);
    alpha /= 255.0;
    alpha += 0.5;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

-(CGPoint)getRandomPoint:(CGSize)bounds {
    CGFloat x = arc4random_uniform((uint32_t) bounds.width);
    CGFloat y = arc4random_uniform((uint32_t) bounds.height);
    return ccp(x, y);
}

-(CGPoint)getRandomPointWithEx:(CGSize)bounds {
    CGFloat x = arc4random_uniform((uint32_t) bounds.width);
    CGFloat y = arc4random_uniform((uint32_t) bounds.height);

    if (y > bounds.height-100 && x < 100) {
        x = 100;
        y = bounds.height-100;
    }
    
    return ccp(x, y);
}

-(CGRect)getRandomFrame:(CGSize)bounds size:(CGSize)size {
    CGFloat x = arc4random_uniform((uint32_t) bounds.width);
    CGFloat y = arc4random_uniform((uint32_t) bounds.height);
    
    //x = clampf(x, 50.0, bounds.width);
    if (y > bounds.height-60 && x < 50) {
        x = 50;
        y = bounds.height-60;
    }
    
    return CGRectMake(x, y, size.width, size.height);
}

-(CGFloat)getRandomRotationRad {
    CGFloat rot = [self getRandomRotation];
    rot = DEGREES_TO_RADIANS(rot);
    
    return rot;
}

-(CGFloat)getRandomRotation {
    return (CGFloat)arc4random_uniform(360);
}

-(CGFloat)getRandomScale {
    CGFloat scale = (CGFloat)arc4random_uniform(10);
    scale /= 10.0;
    
    scale = MAX(0.1, scale);
    
    return scale;
}


// -----------------------------------------------------------------------

@end

