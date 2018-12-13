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

    let links: [Link]
    
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
}
