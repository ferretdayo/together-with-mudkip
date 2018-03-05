//
//  ViewController.swift
//  ar-test
//
//  Created by ともひろ on 2018/03/04.
//  Copyright © 2018年 tomohiro. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var planeNodes:[PlaneNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        //        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        addTapGesture()
        
        //        // Create a new scene
        let mudkipNode = Mudkip.create()
        //        mudkipNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        //        mudkipNode.physicsBody?.categoryBitMask = 1
        //        mudkipNode.physicsBody?.restitution = 0// 弾み具合　0:弾まない 3:弾みすぎ
        //        mudkipNode.physicsBody?.damping = 1  // 空気の摩擦抵抗 1でゆっくり落ちる
        sceneView.scene.rootNode.addChildNode(mudkipNode)
        //
        //        // Set the scene to the view
        //        let mudkipScene = Mudkip.create()
        //        sceneView.scene = mudkipScene
    }
    
    func addTapGesture() {
        //        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        //        self.sceneView.addGestureRecognizer(tapRecognizer)
        let snapshotTap = UITapGestureRecognizer(target: self, action: #selector(self.saveImage(_:)))
        snapshotTap.numberOfTapsRequired = 2
        
        self.sceneView.addGestureRecognizer(snapshotTap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                // 平面を表現するノードを追加する
                let panelNode = PlaneNode(anchor: planeAnchor)
                panelNode.isDisplay = true
                //                panelNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
                //                panelNode.physicsBody?.categoryBitMask = 2
                
                node.addChildNode(panelNode)
                self.planeNodes.append(panelNode)
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor, let planeNode = node.childNodes[0] as? PlaneNode {
                // ノードの位置及び形状を修正する
                planeNode.update(anchor: planeAnchor)
            }
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // セーブを行う
    @objc func saveImage(_ sender: UITapGestureRecognizer) {
        // クリックした UIImageView を取得
        let targetImageView = sender.view! as! SCNView
        
        // その中の UIImage を取得
        let targetImage = targetImageView.snapshot()
        
        // UIImage の画像をカメラロールに画像を保存
        UIImageWriteToSavedPhotosAlbum(targetImage, self, #selector(self.showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // 保存を試みた結果をダイアログで表示
    @objc func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        
        var title = "保存完了"
        var message = "カメラロールに保存しました"
        
        if error != nil {
            title = "エラー"
            message = "保存に失敗しました"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // OKボタンを追加
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // UIAlertController を表示
        self.present(alert, animated: true, completion: nil)
    }
}

