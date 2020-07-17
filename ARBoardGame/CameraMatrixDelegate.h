//
//  CameraMatrixDelegate.h
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 15.03.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CameraMatrixDelegate <NSObject>

- (void) setParametersWithOriginalWidth: (float) originalWidth originalHeight: (float) originalHeight cx: (float) cx cy: (float) cy fx: (float) fx fy: (float) fy;

@end
