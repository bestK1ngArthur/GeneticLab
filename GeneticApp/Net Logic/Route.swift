//
//  Route.swift
//  GeneticApp
//
//  Created by bestK1ng on 06/12/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import Foundation

/// Chromosome
class Route {

    var links: [Link]
    
    var generalWeight: Weight {
        
        var weight: Weight = 0
        
        for link in links {
            weight += link.weight
        }
        
        return weight
    }
    
    init(_ links: [Link]) {
        self.links = links
    }
    
    func makeMutation() {
        
        let range = 1..<(self.links.count-1)
        let index = Int.random(in: range)
        
        var link = links[index]
        link = Link(from: Node(Int.random(in: range)), to: Node(Int.random(in: range)), weight: link.weight)
        links[index] = link
    }
}
