//
//  VisionLibWrapper.h
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 24.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <vlSDK/vlSDK_Apple.h>

#import "CameraMatrixDelegate.h"

@protocol VisionLibDelegate;

@interface VisionLibWrapper : NSObject <vlFrameListenerInterface>

@property id <VisionLibDelegate> delegate;

@property id <CameraMatrixDelegate> cameraMatrixDelegate;

- (VisionLibWrapper *) initWithDelegate: (id <VisionLibDelegate>) delegate cameraMatrixDelegate: (id <CameraMatrixDelegate>) cameraMatrixDelegate andModelFileName: (NSString *) modelFileName;

- (void) process;

- (void) shutDown;

@end
