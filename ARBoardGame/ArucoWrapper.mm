//
//  ArucoWrapper.m
//  ARBoardGame
//
//  Created by Ruben Christian Buhl on 25.02.18.
//  Copyright © 2018 Ruben Christian Buhl. All rights reserved.
//

#import "ArucoWrapper.h"
#import "ARBoardGame-Swift.h"

using namespace std;
using namespace cv;
using namespace aruco;

@interface ArucoWrapper() {
    Ptr<Board> boardPtr;

    Mat cameraMatrix;

    bool isCameraMatrixValid;
    bool gotTargetViewSize;

    CGSize targetViewSize;
}

@end

@implementation ArucoWrapper

int forPoseEstimationRequiredBoardMarkersCount = 2;

- (ArucoWrapper *) initWithDelegate: (id <ArucoDelegate>) delegate andArucoBoard: (ArucoBoard *) arucoBoard {
    self = [super init];

    if (self) {
        self.delegate = delegate;

        boardPtr = [self createBoardFrom: arucoBoard];
    }

    return self;
}

- (void) process: (UIImage *) image {
    if (image && isCameraMatrixValid) {
        SCNMatrix4 boardTransformation;

        bool valid = false;

        Mat imageMat = [self createCVMatFromUIImage: image];

        Board board = *boardPtr.get();

        vector<int> ids;

        vector<vector<Point2f>> corners;

        if (gotTargetViewSize) {
            resize(imageMat, imageMat, cv::Size(targetViewSize.width, targetViewSize.height));
        }

        cvtColor(imageMat, imageMat, COLOR_RGB2GRAY);

        detectMarkers(imageMat, board.dictionary, corners, ids);

        if (ids.size() > 0) {
            Mat distortionCoefficients = Mat::zeros(1, 5, CV_64F);

            Mat rvec;
            Mat tvec;

            int detectedBoardMarkersCount = estimatePoseBoard(corners, ids, boardPtr, cameraMatrix, distortionCoefficients, rvec, tvec);

            valid = detectedBoardMarkersCount >= forPoseEstimationRequiredBoardMarkersCount;

            if (valid) {
                Mat openCVViewMatrix = [self createViewMatrixFromRotationVector: rvec andTranslationVector: tvec];

                Mat sceneKitViewMatrix = [self convertOpenCVMatrixToSceneKitMatrix: openCVViewMatrix];

                boardTransformation = [self createSCNMatrix4FromCVMat: sceneKitViewMatrix];
            }
        }

        [self.delegate setWithBoardTransformation: boardTransformation isValid: valid];
    }
}

- (void) setTargetViewSize: (CGSize) size {
    targetViewSize = size;

    isCameraMatrixValid = false;
    gotTargetViewSize = true;
}

- (void) setParametersWithOriginalWidth: (float) originalWidth originalHeight: (float) originalHeight cx: (float) cx cy: (float) cy fx: (float) fx fy: (float) fy {
    if (!isCameraMatrixValid) {
        cameraMatrix = Mat::zeros(3, 3, CV_64F);

        cameraMatrix.at<double>(0, 0) = fx * targetViewSize.width;
        cameraMatrix.at<double>(0, 2) = cx * targetViewSize.width;
        cameraMatrix.at<double>(1, 1) = fy * targetViewSize.height;
        cameraMatrix.at<double>(1, 2) = cy * targetViewSize.height;
        cameraMatrix.at<double>(2, 2) = 1.0;

        isCameraMatrixValid = true;
    }
}

- (Mat) createViewMatrixFromRotationVector: (Mat) rvec andTranslationVector: (Mat) tvec {
    Mat rotation;

    Mat viewMatrix = Mat::zeros(4, 4, CV_64F);

    Rodrigues(rvec, rotation);

    for (int row = 0; row < rotation.rows; row++) {
        for (int column = 0; column < rotation.cols; column++) {
            viewMatrix.at<double>(row, column) = rotation.at<double>(row, column);
        }

        viewMatrix.at<double>(row, 3) = tvec.at<double>(row, 0);
    }

    viewMatrix.at<double>(3, 3) = 1.0;

    return viewMatrix;
}

- (Mat) convertOpenCVMatrixToSceneKitMatrix: (Mat) openCVMatrix {
    Mat sceneKitMatrix = Mat::zeros(4, 4, CV_64F);
    Mat openCVToSceneKitTransformation = Mat::zeros(4, 4, CV_64F);

    openCVToSceneKitTransformation.at<double>(0, 0) = 1.0;
    openCVToSceneKitTransformation.at<double>(1, 1) = -1.0;
    openCVToSceneKitTransformation.at<double>(2, 2) = -1.0;
    openCVToSceneKitTransformation.at<double>(3, 3) = 1.0;

    openCVMatrix = openCVToSceneKitTransformation * openCVMatrix;

    transpose(openCVMatrix, sceneKitMatrix);

    return sceneKitMatrix;
}

- (Ptr<Board>) createBoardFrom: (ArucoBoard *) arucoBoard {
    int dictionaryID = (int) arucoBoard.dictionaryID;

    Ptr<Dictionary> dictionary = getPredefinedDictionary(dictionaryID);

    vector<int> ids;

    vector<vector<Point3f>> corners;

    for (int i = 0; i < arucoBoard.markers.count; i++) {
        ArucoMarker *marker = arucoBoard.markers[i];

        int markerID = (int) marker.id;

        vector<Point3f> markerCorners = [self getCornersFromRectangle: marker.rectangle];

        ids.push_back(markerID);

        corners.push_back(markerCorners);
    }

    return Board::create(corners, dictionary, ids);
}

- (vector<Point3f>) getCornersFromRectangle: (CGRect) rect {
    vector<Point3f> corners;

    CGFloat minX = rect.origin.x;
    CGFloat minY = rect.origin.y;
    CGFloat maxX = rect.origin.x + rect.size.width;
    CGFloat maxY = rect.origin.y + rect.size.height;

    corners.push_back(Point3f(minX, maxY, 0.0));
    corners.push_back(Point3f(maxX, maxY, 0.0));
    corners.push_back(Point3f(maxX, minY, 0.0));
    corners.push_back(Point3f(minX, minY, 0.0));

    return corners;
}

- (SCNMatrix4) createSCNMatrix4FromCVMat: (Mat) mat {
    SCNMatrix4 scnMatrix4 = SCNMatrix4Identity;

    scnMatrix4.m11 = mat.at<double>(0, 0);
    scnMatrix4.m12 = mat.at<double>(0, 1);
    scnMatrix4.m13 = mat.at<double>(0, 2);
    scnMatrix4.m14 = mat.at<double>(0, 3);
    scnMatrix4.m21 = mat.at<double>(1, 0);
    scnMatrix4.m22 = mat.at<double>(1, 1);
    scnMatrix4.m23 = mat.at<double>(1, 2);
    scnMatrix4.m24 = mat.at<double>(1, 3);
    scnMatrix4.m31 = mat.at<double>(2, 0);
    scnMatrix4.m32 = mat.at<double>(2, 1);
    scnMatrix4.m33 = mat.at<double>(2, 2);
    scnMatrix4.m34 = mat.at<double>(2, 3);
    scnMatrix4.m41 = mat.at<double>(3, 0);
    scnMatrix4.m42 = mat.at<double>(3, 1);
    scnMatrix4.m43 = mat.at<double>(3, 2);
    scnMatrix4.m44 = mat.at<double>(3, 3);

    return scnMatrix4;
}

- (Mat) createCVMatFromUIImage: (UIImage *) image {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);

    CGFloat columns = image.size.width;
    CGFloat rows = image.size.height;

    Mat mat(rows, columns, CV_8UC4);

    CGContextRef contextRef = CGBitmapContextCreate(mat.data, columns, rows, 8, mat.step[0], colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);

    CGContextDrawImage(contextRef, CGRectMake(0, 0, columns, rows), image.CGImage);

    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);

    return mat;
}

@end
