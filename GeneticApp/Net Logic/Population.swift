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

        if let indexToRemove = indexesSet.index(of: to.index) {
            indexesSet.remove(at: indexToRemove)
        }

        var routes: [Route] = []
        
        for _ in 0..<Population.size {
            
            var nodeIndexes = Set(indexesSet)

            var currentLinks: [Link] = []
            var fromNode = from
            while nodeIndexes.isEmpty == false {
             
                if let toIndex = nodeIndexes.randomElement() {
                    nodeIndexes.remove(toIndex)

                    let toNode = Node(toIndex)
                    
                    if let link = self.getLink(links: links, fromNode: fromNode, toNode: toNode) {
                        currentLinks.append(link)
                    }
                    
                    fromNode = toNode
                }
            }
            
            if let link = self.getLink(links: links, fromNode: fromNode, toNode: to) {
                currentLinks.append(link)
            }
            
            routes.append(Route(currentLinks))
        }

        return Population(routes: routes)
    }
    
    private static func getLink(links: [Link], fromNode: Node, toNode: Node) -> Link? {
        
        var resultLink: Link?
        
        for link in links {
            
            if (link.from.index == fromNode.index) && (link.to.index == toNode.index) {
                resultLink = link
                break
            } else if (link.from.index == toNode.index) && (link.to.index == fromNode.index) {
                resultLink = link.reversed
            }
        }
            
        return resultLink
    }
}

extension Population {
    
    static func merge(first: Route, second: Route) -> Route {
        
        let range = 1..<(first.links.count-1)
        let firstGeneIndex = Int.random(in: range)
        let secondGeneIndex = Int.random(in: range)
        
        var links = first.links
        
        links[firstGeneIndex] = second.links[firstGeneIndex]
        links[secondGeneIndex] = second.links[secondGeneIndex]
        
        return Route(links)
    }
    
    func nextPopulation() -> Population {
        
        // Selection
        
        let sortedRoutes = routes.sorted { (first, second) -> Bool in
            return first.generalWeight < second.generalWeight
        }
        let bestRoutes: [Route] = Array(sortedRoutes.prefix(upTo: 10))
        
        // Crossing & mutating
        
        var newRoutes: [Route] = []
        for firstRoute in bestRoutes {
            for secondRoute in bestRoutes {
                //if firstRoute.generalWeight != secondRoute.generalWeight {
                    let route = Population.merge(first: firstRoute, second: secondRoute)
                    if Int.random(in: 0..<1) % 2 == 0 {
                        route.makeMutation()
                    }
                    route.makeMutation()
                    newRoutes.append(route)
                //}
            }
        }
        
        newRoutes.shuffle()

//        if newRoutes.count < Population.size {
//            newRoutes.append(contentsOf: sortedRoutes)
//        }
        
        return Population(routes: Array(newRoutes.prefix(upTo: Population.size))) ?? self
    }
    
    func nextPopulation(count: Int) -> Population {
        var population = self
        
        for _ in 0..<count {
            population = population.nextPopulation()
        }
        
        return population
    }
    
    func bestRoute() -> Route {
        
        let sortedRoutes = routes.sorted { (first, second) -> Bool in
            return first.generalWeight < second.generalWeight
        }

        return sortedRoutes.first!
    }
}
