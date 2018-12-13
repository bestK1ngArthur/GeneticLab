//
//  Population.swift
//  GeneticApp
//
//  Created by bestK1ng on 07/12/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import Foundation

class Population {

    static var size = 20
    static var nodesCount = 10
    
    var routes: [Route]
    
    init?(routes: [Route]) {
        guard routes.count == Population.size else {
            return nil
        }
        
        self.routes = routes
    }
}

extension Population {
    
    static func generatePopulation(for links: [Link], from: Node, to: Node) -> Population? {
        
        let safeRange = 0..<Population.nodesCount
        guard (safeRange ~= from.index) && (safeRange ~= to.index) else {
            return nil
        }
        
        var indexesSet = Set(0..<Population.nodesCount)
        
        if let indexToRemove = indexesSet.index(of: from.index) {
            indexesSet.remove(at: indexToRemove)
        }

        if let indexToRemove = indexesSet.index(of: from.index) {
            indexesSet.remove(at: indexToRemove)
        }

        var routes: [Route] = []
        
        for _ in 0..<Population.size {
            
            var nodeIndexes = Set(indexesSet)

            var links: [Link] = []
            var fromNode = from
            while nodeIndexes.isEmpty == false {
             
                if let toIndex = nodeIndexes.randomElement() {
                    nodeIndexes.remove(toIndex)

                    let toNode = Node(toIndex)

                    if let link = links.first(where: { link -> Bool in
                        return ((link.from.index == fromNode.index) && (link.to.index == toNode.index)) ||
                               ((link.from.index == toNode.index) && (link.to.index == fromNode.index))
                    }) {
                        links.append(link)
                    }
                    
                    fromNode = toNode
                }
            }
            
            routes.append(Route(links))
        }
        
        return Population(routes: routes)
    }
    
    private func getLink(links: [Link], fromNode: Node, toNode: Node) -> Link? {
        
       return nil
    }
}
