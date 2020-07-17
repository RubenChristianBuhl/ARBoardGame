//
//  VisionLibWrapper.m
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 24.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import <GLKit/GLKit.h>

#import "VisionLibWrapper.h"
#import "ARBoardGame-Swift.h"

@interface VisionLibWrapper() {
    vlSDK *visionLibSDK;

    bool gotInitPose;
    bool wasLastModelTransformationValid;

    SCNMatrix4 initPose;
}

@end

@implementation VisionLibWrapper

NSString *replaceModelURIFileNamePattern = @"(\"modelURI\"\\s*:\\s*\").*?(\")";
NSString *replaceModelURIFileNameTemplate = @"$1%@$2";

NSString *fileScheme = @"file://";

NSString *visionLibDirectory = @"VisionLib";
NSString *modelsDirectory = @"Models";

NSString *trackingConfigurationDirectory = @"TrackingConfigurations";
NSString *defaultTrackingConfigurationFileName = @"defaultConfiguration";
NSString *modelTrackingConfigurationFileName = @"modelConfiguration";
NSString *trackingConfigurationFileExtension = @"vl";

NSString *licenseDirectory = @"Licenses";
NSString *licenseFileName = @"academicLicense";
NSString *licenseFileExtension = @"xml";

char *licenseEnvironmentVariableName = "TALIC_LICENSE_FILE";

- (VisionLibWrapper *) initWithDelegate: (id <VisionLibDelegate>) delegate cameraMatrixDelegate: (id <CameraMatrixDelegate>) cameraMatrixDelegate andModelFileName: (NSString *) modelFileName {
    self = [super init];

    if (self) {
        self.delegate = delegate;
        self.cameraMatrixDelegate = cameraMatrixDelegate;

        [self initializeAndRunSDKWithModelFileName: modelFileName];
    }

    return self;
}

- (void) process {
    [visionLibSDK process];
}

- (void) shutDown {
    [visionLibSDK shutDown];
}

- (void) onTrackerInitialized: (bool) worked {
    [visionLibSDK getInitPose];
}

- (void) onInitPoseMatrix: (float *) m {
    if (!gotInitPose) {
        initPose = SCNMatrix4Invert(SCNMatrix4FromGLKMatrix4(GLKMatrix4MakeWithArray(m)));

        [self.delegate setWithModelTransformation: initPose isValid: false];

        gotInitPose = true;
    }
}

- (void) onIntrinsicData: (float *) data {
    SCNMatrix4 projectionTransformation = SCNMatrix4FromGLKMatrix4(GLKMatrix4MakeWithArray(data));

    [self.delegate setWithCameraProjectionTransformation: projectionTransformation];
}

- (void) onIntrinsicDataWithWidth: (float) width height: (float) height cx: (float) cx cy: (float) cy fx: (float) fx fy: (float) fy {
    [self.cameraMatrixDelegate setParametersWithOriginalWidth: width originalHeight: height cx: cx cy: cy fx: fx fy: fy];
}

- (void) onExtrinsicData: (float *) data isValid: (bool) valid {
    SCNMatrix4 modelTransformation = initPose;

    if (valid) {
        modelTransformation = SCNMatrix4Invert(SCNMatrix4FromGLKMatrix4(GLKMatrix4MakeWithArray(data)));
    } else if (wasLastModelTransformationValid) {
        [visionLibSDK resetHard];
    }

    [self.delegate setWithModelTransformation: modelTransformation isValid: valid];

    wasLastModelTransformationValid = valid;
}

- (void) onMetalImageTexture: (id <MTLTexture>) texture withRotationMatrix: (float *) m {
    SCNMatrix4 imageTransformation = SCNMatrix4FromGLKMatrix4(GLKMatrix4MakeWithArray(m));

    [self.delegate setWithCameraImage: texture];
    [self.delegate setWithCameraImageTransformation: imageTransformation];
}

- (void) initializeAndRunSDKWithModelFileName: (NSString *) modelFileName {
    [self setLicenseEnvironmentVariable];

    [self createModelTrackingConfigurationWithModelFileName: modelFileName];

    visionLibSDK = [[vlSDK alloc] initTrackerWithURI: [self getModelTrackingConfigurationURI] andDelegate: self];

    [visionLibSDK configureExtrinsicCameraInverted: true];
    [visionLibSDK run];
}

- (void) setLicenseEnvironmentVariable {
    NSString *licenseFilePath = [[visionLibDirectory stringByAppendingPathComponent: licenseDirectory] stringByAppendingPathComponent: licenseFileName];

    NSString *licenseFile = [NSBundle.mainBundle pathForResource: licenseFilePath ofType: licenseFileExtension];

    setenv(licenseEnvironmentVariableName, [licenseFile UTF8String], true);
}

- (NSString *) getModelTrackingConfigurationURI {
    return [fileScheme stringByAppendingPathComponent: [self getModelTrackingConfigurationFile]];
}

- (NSString *) getModelTrackingConfigurationFile {
    return [[NSFileManager.defaultManager.temporaryDirectory.path stringByAppendingPathComponent: modelTrackingConfigurationFileName] stringByAppendingPathExtension: trackingConfigurationFileExtension];
}

- (NSString *) getDefaultTrackingConfigurationFile {
    NSString *trackingConfigurationFilePath = [[visionLibDirectory stringByAppendingPathComponent: trackingConfigurationDirectory] stringByAppendingPathComponent: defaultTrackingConfigurationFileName];

    return [NSBundle.mainBundle pathForResource: trackingConfigurationFilePath ofType: trackingConfigurationFileExtension];
}

- (NSString *) getModelFileFromModelsFileName: (NSString *) modelFileName  {
    NSString *modelFilePath = [modelsDirectory stringByAppendingPathComponent: modelFileName];

    return [NSBundle.mainBundle pathForResource: modelFilePath ofType: nil];
}

- (void) createModelTrackingConfigurationWithModelFileName: (NSString *) modelFileName {
    NSString *defaultTrackingConfiguration = [NSString stringWithContentsOfFile: [self getDefaultTrackingConfigurationFile] encoding: NSUTF8StringEncoding error: nil];

    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern: replaceModelURIFileNamePattern options: NSRegularExpressionAllowCommentsAndWhitespace error: nil];

    NSRange range = NSMakeRange(0, defaultTrackingConfiguration.length);

    NSString *template = [NSString stringWithFormat: replaceModelURIFileNameTemplate, [self getModelFileFromModelsFileName: modelFileName]];

    NSString *modelTrackingConfiguration = [regularExpression stringByReplacingMatchesInString: defaultTrackingConfiguration options: 0 range: range withTemplate: template];

    [modelTrackingConfiguration writeToFile: [self getModelTrackingConfigurationFile] atomically: true encoding: NSUTF8StringEncoding error: nil];
}

@end
