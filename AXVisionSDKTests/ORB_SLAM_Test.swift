//
//  ORB_SLAM_Test.swift
//  AXVisionSDKTests
//
//  Created by lyj on 2020/12/27.
//  Copyright © 2020 lyj. All rights reserved.
//

import XCTest

import AXVisionSDK

class ORB_SLAM_Test: XCTestCase {

    struct TrackRes {
        let state: Int32
        let nKF: Int32
        let nMP: Int32
        let poseR: [Double]?
        let pose_t: [Double]?
        
        init (state: Int32, nKF: Int32, nMP: Int32, poseR: [Double]?, pose_t: [Double]?) {
            self.state = state
            self.nKF = nKF
            self.nMP = nMP
            self.poseR = poseR
            self.pose_t = pose_t
        }
    }
    
    func getTrackRes(orb_slamer: ORB_SLAMer, img: UIImage) -> TrackRes {
        orb_slamer.trackFrame(img)
        let state = orb_slamer.getTrackingState()
        let nKF = orb_slamer.getnKF()
        let nMP = orb_slamer.getnMP()
        let poseR: [Double]?
        let pose_t: [Double]?
        if state == 3 {
            poseR = orb_slamer.getCurrentPose_R() as! [Double]
            pose_t = orb_slamer.getCurrentPose_t() as! [Double]
        } else {
            poseR = nil
            pose_t = nil
        }
        return TrackRes(state: state, nKF: nKF, nMP: nMP, poseR: poseR, pose_t: pose_t)
    }
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ORB_SLAM() {
        let testDataDir = ProcessInfo.processInfo.environment["TESTDATADIR"]!
        
        let imageFd = testDataDir + "/test_data/images/"
        let img0Fn = imageFd + "scene_000.png"
        let img1Fn = imageFd + "scene_038.png"
        let img2Fn = imageFd + "scene_066.png"
        let img3Fn = imageFd + "scene_068.png"
        
        let feedWidth:Float = 320
        let feedHeight:Float = 240
        
        let img0 = CommonUtils.readImage(withPath: img0Fn)!
        let img1 = CommonUtils.readImage(withPath: img1Fn)!
        let img2 = CommonUtils.readImage(withPath: img2Fn)!
        let img3 = CommonUtils.readImage(withPath: img3Fn)!
        
        let originWidth = Float(img0.size.width)
        let originHeight = Float(img0.size.height)
        let input0 = CommonUtils.resizeImage(with: img0, xscale: feedWidth/originWidth, yscale: feedHeight/originHeight)!
        let input1 = CommonUtils.resizeImage(with: img1, xscale: feedWidth/originWidth, yscale: feedHeight/originHeight)!
        let input2 = CommonUtils.resizeImage(with: img2, xscale: feedWidth/originWidth, yscale: feedHeight/originHeight)!
        let input3 = CommonUtils.resizeImage(with: img3, xscale: feedWidth/originWidth, yscale: feedHeight/originHeight)!
        
        let orb_slamer = ORB_SLAMer.init()
        orb_slamer.initORB_SLAM(withVoc: "ORBvocForTest")
        
        let trackGT = TrackRes(state: 3, nKF: 2, nMP: 120,
                               poseR: [0.9947498, 0.038644526, -0.09476022, -0.041515633, 0.99873084, -0.028516013, 0.093537964, 0.032300327, 0.9950916],
                               pose_t: [0.12645715, -0.016172642, 0.0071656657])
        var trackRes: TrackRes
        trackRes = getTrackRes(orb_slamer: orb_slamer, img: input0)
        trackRes = getTrackRes(orb_slamer: orb_slamer, img: input1)
        trackRes = getTrackRes(orb_slamer: orb_slamer, img: input2)
        XCTAssertEqual(trackRes.state, 2)
        trackRes = getTrackRes(orb_slamer: orb_slamer, img: input3)
        XCTAssertEqual(trackRes.state, trackGT.state)
        XCTAssertEqual(trackRes.nKF, trackGT.nKF)
        XCTAssertEqual(trackRes.nMP, trackGT.nMP)
        for i in 0 ..< trackRes.poseR!.count {
            XCTAssertEqual(trackRes.poseR![i], trackGT.poseR![i], accuracy: 1e-6, "Test error in compute camera pose R")
        }
        for i in 0 ..< trackRes.pose_t!.count {
            XCTAssertEqual(trackRes.pose_t![i], trackGT.pose_t![i], accuracy: 1e-6, "Test error in compute camera pose t")
        }

    }

    func testPerformance_ORB_SLAM() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
