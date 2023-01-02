//
//  ViewController.swift
//  ARRuler
//
//  Created by Tanaka Mawoyo on 02.01.23.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        

        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints] //show points
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //locate point if it exists
        if let touchLocation = touches.first?.location(in: sceneView){
            
            if let query = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .any) {
            
                   let hitTestResults = sceneView.session.raycast(query)
            
                   if let hitResult = hitTestResults.first {
                       addDot(at: hitResult)
                   }
               }
            print("A touch was detected")
        }
    }
    
    func addDot(at hitResult: ARRaycastResult){
        
        let dotGeometry = SCNSphere(radius: 0.005)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dotGeometry.materials = [material]
        
        let dotNode = SCNNode(geometry: dotGeometry)
        dotNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                      hitResult.worldTransform.columns.3.y,
                                      hitResult.worldTransform.columns.3.z)
        
        dotNode.geometry = dotGeometry
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }


}
