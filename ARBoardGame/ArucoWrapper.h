//
//  ArucoWrapper.h
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 25.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/aruco.hpp>
#endif

#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>
#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import <GameplayKit/GameplayKit.h>

#import "CameraMatrixDelegate.h"

@protocol ArucoDelegate;

@class ArucoBoard;

@interface ArucoWrapper : NSObject <CameraMatrixDelegate>

@property id <ArucoDelegate> delegate;

- (ArucoWrapper *) initWithDelegate: (id <ArucoDelegate>) delegate andArucoBoard: (ArucoBoard *) arucoBoard;

- (void) process: (UIImage *) image;

- (void) setTargetViewSize: (CGSize) size;

@end
