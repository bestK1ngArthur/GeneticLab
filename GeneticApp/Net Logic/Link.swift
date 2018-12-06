//
//  Link.swift
//  GeneticApp
//
//  Created by bestK1ng on 06/12/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import Foundation

typealias Weight = Int

/// Gene
class Link {
    
    let from: Node
    let to: Node
    let weight: Weight
    
    init(from: Node, to: Node, weight: Weight) {
        self.from = from
        self.to = to
        self.weight = weight
    }
}
