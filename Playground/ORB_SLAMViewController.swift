//
//  ORB_SLAMViewController.swift
//  Playground
//
//  Created by lyj on 2020/12/04.
//  Copyright © 2020 lyj. All rights reserved.
//

import Foundation
import UIKit

import AXVisionSDK
import SceneKit
import simd

class ORB_SLAMViewController : UIViewController {
    
    @IBOutlet weak var fpsText: UILabel!
    @IBOutlet weak var stateText: UILabel!
    @IBOutlet weak var nKFText: UILabel!
    @IBOutlet weak var nMPText: UILabel!
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!

    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var imageView: UIImageView!
    
    var profiler: CommonProfiler!
    var orb_slamer: ORB_SLAMer!

    var poseCount = 0
    var initialPose = true
    var prevPoint: SCNVector3!
    var geometryNode: SCNNode!
    
    private var orb_SLAMManager = ORB_SLAMManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profiler = CommonProfiler.init()

        initORB_SLAM()
        sceneSetup()
        
        orb_SLAMManager.delegate = self
    }
    
    func sceneSetup() {
        let scene = SCNScene()
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white:0.67, alpha:1.0)
        scene.rootNode.addChildNode(ambientLightNode)

        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light!.type = SCNLight.LightType.omni
        omniLightNode.light!.color = UIColor(white:0.75, alpha:1.0)
        omniLightNode.position = SCNVector3Make(0, 10, 10)
        scene.rootNode.addChildNode(omniLightNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 3)
        scene.rootNode.addChildNode(cameraNode)
        
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.black
        
        geometryNode = SCNNode()
    }
    
    func resetSceneView () {
        initialPose = true
        geometryNode = SCNNode()
        updateGeometry()
    }
    
    func updateGeometry () {
        geometryNode.removeFromParentNode()
        sceneView.scene!.rootNode.addChildNode(geometryNode)
    }
    
    func addPose(point: SCNVector3) {
        if !initialPose {
            geometryNode.addChildNode(lineBetweenX(X: prevPoint, Y: point))
        } else {
            initialPose = false
        }
        prevPoint = point
        poseCount += 1
        if poseCount % 100 == 0 {
            geometryNode = geometryNode.flattenedClone()
            poseCount = 0
        }
        updateGeometry()
    }
    
    func lineBetweenX(X: SCNVector3, Y: SCNVector3) -> SCNNode {
        // Positions
        let vertexSource = SCNGeometrySource(vertices: [X, Y])
        let indices: [Int32] = [0, 1]
        let ptr = UnsafeBufferPointer(start: indices, count: indices.count)
        let indexData = Data(buffer: ptr)
        let element = SCNGeometryElement(data: indexData, primitiveType: SCNGeometryPrimitiveType.line, primitiveCount: 1, bytesPerIndex: MemoryLayout<Int32>.size)
        let line = SCNGeometry(sources: [vertexSource], elements: [element])
        let lineNode = SCNNode(geometry: line)
        return lineNode
    }
    
    func initORB_SLAM() {
        orb_slamer = ORB_SLAMer.init()
        startBtn.isEnabled = false
        resetBtn.isEnabled = false
        stateText.text = "state: Loading Vocabulary"
        DispatchQueue.global(qos: .userInteractive).async {
            self.orb_slamer.initORB_SLAM()
            DispatchQueue.main.async {
                self.stateText.text = "state: vocabulary loaded"
                self.startBtn.isEnabled = true
                self.resetBtn.isEnabled = true
            }
        }
    }

    @IBAction func onCloseBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onStartBtn(_ sender: Any) {
        orb_SLAMManager.runFromAVFoundation()
    }
    
    @IBAction func onResetBtn(_ sender: Any) {
        orb_slamer.requestSLAMReset()
        sceneSetup()
        resetSceneView()
        nKFText.text = "nKF:"
        nMPText.text = "nMP:"
    }
}

extension ORB_SLAMViewController: ORB_SLAMManagerDelegate {
    func showCurFrame(image: UIImage) {
        DispatchQueue.main.sync {
            imageView.image = image
        }
    }
    
    func trackCurFrame(image: UIImage) {
        orb_slamer.trackFrame(image)
    }
    
    func startProfiler() {
        profiler.start()
    }
    
    func endProfiler() {
        profiler.end()
    }
    
    func updateInfoDisplay() {
        DispatchQueue.main.sync {
            let curFPS = "fps: \(1.0 / self.profiler.getAverageTime())"
            self.fpsText.text = curFPS
            
            switch orb_slamer.getTrackingState() {
                case -1:
                    self.stateText.text = "state: SYSTEM_NOT_READY"
                case 0:
                    self.stateText.text = "state: NO_IMAGE_YET"
                case 1:
                    self.stateText.text = "state: NOT_INITIALIZED"
                case 2:
                    self.stateText.text = "state: INITIALIZING"
                case 3:
                    self.stateText.text = "state: WORKING"
                    let cur_nKF = orb_slamer.getnKF()
                    let cur_nMP = orb_slamer.getnMP()
                    self.nKFText.text = "nKF: \(cur_nKF)"
                    self.nMPText.text = "nMP: \(cur_nMP)"
                    guard let pose_R = orb_slamer.getCurrentPose_R() as? [Float],
                        let pose_t = orb_slamer.getCurrentPose_t() as? [Float] else {
                            return
                    }
                    let R = simd_float3x3(rows: [
                        simd_float3(pose_R[0], pose_R[1], pose_R[2]),
                        simd_float3(pose_R[3], pose_R[4], pose_R[5]),
                        simd_float3(pose_R[6], pose_R[7], pose_R[8])
                    ])
                    let t = simd_float3(pose_t[0], pose_t[1], pose_t[2])
                    let center = simd_mul(-R.transpose, t)
                    addPose(point: SCNVector3Make(center[0], -center[1], center[2]))
                case 4:
                    self.stateText.text = "state: LOST"
                default:
                    self.stateText.text = "state: STATE UNKNOWN"
            }
        }
    }
}
