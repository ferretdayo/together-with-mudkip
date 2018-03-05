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
    static func create() -> SCNNode {
        let scene = SCNScene(named: "art.scnassets/Mudkip_OpenCollada.scn")!
        let node = scene.rootNode.childNode(withName: "mudkip", recursively: true)
        return node!
    }
}
