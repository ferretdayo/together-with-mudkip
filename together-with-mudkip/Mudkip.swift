//
//  Mudkip.swift
//  together-with-mudkip
//
//  Created by ともひろ on 2018/03/06.
//  Copyright © 2018年 tomohiro. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Mudkip {
    let scene: SCNScene
    let node: SCNNode
    
    init() {
        scene = SCNScene(named: "art.scnassets/Mudkip_OpenCollada.scn")!
        node = scene.rootNode.childNode(withName: "mudkip", recursively: true)!
        node.scale = SCNVector3(0.1, 0.1, 0.1)
    }
    
    func getNode() -> SCNNode {
        return node
    }
}
