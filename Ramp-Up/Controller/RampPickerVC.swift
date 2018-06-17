//
//  RampPickerVC.swift
//  Ramp-Up
//
//  Created by Arif Onur Şen on 27.02.2018.
//  Copyright © 2018 LiniaTech. All rights reserved.
//

import UIKit
import SceneKit

class RampPickerVC: UIViewController {

    var sceneView: SCNView!
    var size: CGSize!
    
    weak var rampPlacerVC: RampPlacerVC!
    
    init(size: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.insertSubview(sceneView, at: 0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector (handleTap(_:)))
        sceneView.addGestureRecognizer(tap)
        
        let scene = SCNScene(named: "art.scnassets/ramps.scn")
        sceneView.scene = scene
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene?.rootNode.camera = camera
        
        let pipe = Ramp.getPipe()
        Ramp.startRotation(node: pipe)
        scene?.rootNode.addChildNode(pipe)
        
        let pyramid = Ramp.getPyramid()
        Ramp.startRotation(node: pyramid)
        scene?.rootNode.addChildNode(pyramid)
        
        let quarter = Ramp.getQuarter()
        Ramp.startRotation(node: quarter)
        scene?.rootNode.addChildNode(quarter)
        
        preferredContentSize = size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let p = gestureRecognizer.location(in: sceneView)
        let hitResult = sceneView.hitTest(p, options: [:])
        
        if hitResult.count > 0 {
            let node = hitResult[0].node
            rampPlacerVC.onRampSelected(node.name!)
            dismiss(animated: true, completion: nil)
        }
    }

}
