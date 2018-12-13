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

extension Link {
    
    static func generateLinks(size: Int, range: Range<Int>) -> [Link] {
        
        var links: [Link] = []
        
        for firstNodeIndex in 0..<size {
            for secondNodeIndex in 0..<size {

                if firstNodeIndex == secondNodeIndex {
                    continue
                }
                
                let weight = Int.random(in: range)
                let link = Link(from: Node(firstNodeIndex), to: Node(secondNodeIndex), weight: weight)
                
                links.append(link)
            }
        }
        
        return links
    }
}
