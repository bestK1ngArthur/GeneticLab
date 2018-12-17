//
//  MainViewController.swift
//  GeneticApp
//
//  Created by bestK1ng on 04/12/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import Cocoa

let linkSize = 10
let weightRange = 0..<10

class MainViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var fromIndexTextField: NSTextField!
    @IBOutlet weak var toIndexTextField: NSTextField!
    
    @IBOutlet weak var resultTitleLabel: NSTextField!
    @IBOutlet weak var resultRouteLabel: NSTextField!
    
    @IBOutlet weak var text1x10field: NSTextField!
    @IBOutlet weak var text1x9field: NSTextField!
    @IBOutlet weak var text1x8field: NSTextField!
    @IBOutlet weak var text1x7field: NSTextField!
    @IBOutlet weak var text1x6field: NSTextField!
    @IBOutlet weak var text1x5field: NSTextField!
    @IBOutlet weak var text1x4field: NSTextField!
    @IBOutlet weak var text1x3field: NSTextField!
    @IBOutlet weak var text1x2field: NSTextField!
    @IBOutlet weak var text2x10field: NSTextField!
    @IBOutlet weak var text2x9field: NSTextField!
    @IBOutlet weak var text2x8field: NSTextField!
    @IBOutlet weak var text2x7field: NSTextField!
    @IBOutlet weak var text2x6field: NSTextField!
    @IBOutlet weak var text2x5field: NSTextField!
    @IBOutlet weak var text2x4field: NSTextField!
    @IBOutlet weak var text2x3field: NSTextField!
    @IBOutlet weak var text3x10field: NSTextField!
    @IBOutlet weak var text3x9field: NSTextField!
    @IBOutlet weak var text3x8field: NSTextField!
    @IBOutlet weak var text3x7field: NSTextField!
    @IBOutlet weak var text3x6field: NSTextField!
    @IBOutlet weak var text3x5field: NSTextField!
    @IBOutlet weak var text3x4field: NSTextField!
    @IBOutlet weak var text4x10field: NSTextField!
    @IBOutlet weak var text4x9field: NSTextField!
    @IBOutlet weak var text4x8field: NSTextField!
    @IBOutlet weak var text4x7field: NSTextField!
    @IBOutlet weak var text4x6field: NSTextField!
    @IBOutlet weak var text4x5field: NSTextField!
    @IBOutlet weak var text5x10field: NSTextField!
    @IBOutlet weak var text5x9field: NSTextField!
    @IBOutlet weak var text5x8field: NSTextField!
    @IBOutlet weak var text5x7field: NSTextField!
    @IBOutlet weak var text5x6field: NSTextField!
    @IBOutlet weak var text6x10field: NSTextField!
    @IBOutlet weak var text6x9field: NSTextField!
    @IBOutlet weak var text6x8field: NSTextField!
    @IBOutlet weak var text6x7field: NSTextField!
    @IBOutlet weak var text7x10field: NSTextField!
    @IBOutlet weak var text7x9field: NSTextField!
    @IBOutlet weak var text7x8field: NSTextField!
    @IBOutlet weak var text8x10field: NSTextField!
    @IBOutlet weak var text8x9field: NSTextField!
    @IBOutlet weak var text9x10field: NSTextField!
    
    private let rowHeight: CGFloat = 23
    
    private var currentPopulation: Population?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        generatePopulation(self)
        generateWeights(self)
        
        hideResultRoute()
    }
    
    func showPopulation(_ population: Population, in tableView: NSTableView) {
        currentPopulation = population
        tableView.reloadData()
    }
    
    @IBAction func generateWeights(_ sender: Any) {
        showLinksWeights(links: Link.generateLinks(size: 10, range: weightRange))
    }
    
    @IBAction func generatePopulation(_ sender: Any) {
        hideResultRoute()
        
        let fromIndex = Int(fromIndexTextField.stringValue) ?? 0
        let toIndex = Int(toIndexTextField.stringValue) ?? 9
        
        let links = Link.generateLinks(size: linkSize, range: weightRange)
        showLinksWeights(links: links)
        
        if let newPopulation = Population.generatePopulation(for: links, from: Node(fromIndex), to: Node(toIndex)) {
            showPopulation(newPopulation, in: tableView)
        }
    }
    
    @IBAction func createPopulation(_ sender: Any) {
        hideResultRoute()
        
        let fromIndex = Int(fromIndexTextField.stringValue) ?? 0
        let toIndex = Int(toIndexTextField.stringValue) ?? 9
        
        let links = getLinks()
        
        if let newPopulation = Population.generatePopulation(for: links, from: Node(fromIndex), to: Node(toIndex)) {
            showPopulation(newPopulation, in: tableView)
        }
    }
    
    private func showResultRoute(_ route: Route) {
        
        var result = ""
        for link in route.links {
            result += "\(link.from.index)→"
        }
        
        if let lastIndex = route.links.last?.to.index {
            result += "\(lastIndex)"
        }
        
        resultTitleLabel.stringValue = "Результат (\(route.generalWeight))"
        resultRouteLabel.stringValue = result
        
        resultTitleLabel.isHidden = false
        resultRouteLabel.isHidden = false
    }
    
    private func hideResultRoute() {
        resultTitleLabel.isHidden = true
        resultRouteLabel.isHidden = true
    }
    
    @IBAction func showNextPopulation(_ sender: Any) {
        self.currentPopulation = self.currentPopulation?.nextPopulation()
        tableView.reloadData()
        
        if let route = self.currentPopulation?.bestRoute() {
            showResultRoute(route)
        }
    }
    
    @IBAction func showFuturePopulation(_ sender: Any) {
        self.currentPopulation = self.currentPopulation?.nextPopulation(count: 50)
        tableView.reloadData()
        
        if let route = self.currentPopulation?.bestRoute() {
            showResultRoute(route)
        }
    }
}

extension MainViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Population.nodesCount
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return rowHeight
    }
}

extension MainViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let tableColumn = tableColumn, let columnIndex = tableView.tableColumns.firstIndex(of: tableColumn) else {
            return nil
        }
        
        guard let population = currentPopulation, let node = getNode(from: population, tableColumn: columnIndex, tableRow: row) else {
            return nil
        }
        
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "NodeCell"), owner: nil) as? NSTableCellView else {
            return nil
        }
        
        cell.textField?.stringValue = "\(node.index)"
        
        return cell
    }
   
}

extension MainViewController {
    
    private func getNode(from population: Population, tableColumn: Int, tableRow: Int) -> Node? {
     
        var node: Node?
        if tableRow == population.routes[tableColumn].links.count {
            node = population.routes[tableColumn].links[tableRow-1].to
        } else if tableRow < population.routes[tableColumn].links.count  {
            node = population.routes[tableColumn].links[tableRow].from
        }
        
        return node
    }
    
    private func getLinks() -> [Link] {
        
        var links: [Link] = []

        links.append(Link(from: Node(0), to: Node(9), weight: Weight(text1x10field.intValue)))
        links.append(Link(from: Node(0), to: Node(8), weight: Weight(text1x9field.intValue)))
        links.append(Link(from: Node(0), to: Node(7), weight: Weight(text1x8field.intValue)))
        links.append(Link(from: Node(0), to: Node(6), weight: Weight(text1x7field.intValue)))
        links.append(Link(from: Node(0), to: Node(5), weight: Weight(text1x6field.intValue)))
        links.append(Link(from: Node(0), to: Node(4), weight: Weight(text1x5field.intValue)))
        links.append(Link(from: Node(0), to: Node(3), weight: Weight(text1x4field.intValue)))
        links.append(Link(from: Node(0), to: Node(2), weight: Weight(text1x3field.intValue)))
        links.append(Link(from: Node(0), to: Node(1), weight: Weight(text1x2field.intValue)))
        links.append(Link(from: Node(1), to: Node(9), weight: Weight(text2x10field.intValue)))
        links.append(Link(from: Node(1), to: Node(8), weight: Weight(text2x9field.intValue)))
        links.append(Link(from: Node(1), to: Node(7), weight: Weight(text2x8field.intValue)))
        links.append(Link(from: Node(1), to: Node(6), weight: Weight(text2x7field.intValue)))
        links.append(Link(from: Node(1), to: Node(5), weight: Weight(text2x6field.intValue)))
        links.append(Link(from: Node(1), to: Node(4), weight: Weight(text2x5field.intValue)))
        links.append(Link(from: Node(1), to: Node(3), weight: Weight(text2x4field.intValue)))
        links.append(Link(from: Node(1), to: Node(2), weight: Weight(text2x3field.intValue)))
        links.append(Link(from: Node(2), to: Node(9), weight: Weight(text3x10field.intValue)))
        links.append(Link(from: Node(2), to: Node(8), weight: Weight(text3x9field.intValue)))
        links.append(Link(from: Node(2), to: Node(7), weight: Weight(text3x8field.intValue)))
        links.append(Link(from: Node(2), to: Node(6), weight: Weight(text3x7field.intValue)))
        links.append(Link(from: Node(2), to: Node(5), weight: Weight(text3x6field.intValue)))
        links.append(Link(from: Node(2), to: Node(4), weight: Weight(text3x5field.intValue)))
        links.append(Link(from: Node(2), to: Node(3), weight: Weight(text3x4field.intValue)))
        links.append(Link(from: Node(3), to: Node(9), weight: Weight(text4x10field.intValue)))
        links.append(Link(from: Node(3), to: Node(8), weight: Weight(text4x9field.intValue)))
        links.append(Link(from: Node(3), to: Node(7), weight: Weight(text4x8field.intValue)))
        links.append(Link(from: Node(3), to: Node(6), weight: Weight(text4x7field.intValue)))
        links.append(Link(from: Node(3), to: Node(5), weight: Weight(text4x6field.intValue)))
        links.append(Link(from: Node(3), to: Node(4), weight: Weight(text4x5field.intValue)))
        links.append(Link(from: Node(4), to: Node(9), weight: Weight(text5x10field.intValue)))
        links.append(Link(from: Node(4), to: Node(8), weight: Weight(text5x9field.intValue)))
        links.append(Link(from: Node(4), to: Node(7), weight: Weight(text5x8field.intValue)))
        links.append(Link(from: Node(4), to: Node(6), weight: Weight(text5x7field.intValue)))
        links.append(Link(from: Node(4), to: Node(5), weight: Weight(text5x6field.intValue)))
        links.append(Link(from: Node(5), to: Node(9), weight: Weight(text6x10field.intValue)))
        links.append(Link(from: Node(5), to: Node(8), weight: Weight(text6x9field.intValue)))
        links.append(Link(from: Node(5), to: Node(7), weight: Weight(text6x8field.intValue)))
        links.append(Link(from: Node(5), to: Node(6), weight: Weight(text6x7field.intValue)))
        links.append(Link(from: Node(6), to: Node(9), weight: Weight(text7x10field.intValue)))
        links.append(Link(from: Node(6), to: Node(8), weight: Weight(text7x9field.intValue)))
        links.append(Link(from: Node(6), to: Node(7), weight: Weight(text7x8field.intValue)))
        links.append(Link(from: Node(7), to: Node(9), weight: Weight(text8x10field.intValue)))
        links.append(Link(from: Node(7), to: Node(8), weight: Weight(text8x9field.intValue)))
        links.append(Link(from: Node(8), to: Node(9), weight: Weight(text9x10field.intValue)))

        return links
    }
    
    private func showLinksWeights(links: [Link]) {
        
        if let link = findLink(in: links, from: 0, to: 9) {
            text1x10field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 0, to: 8) {
            text1x9field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 0, to: 7) {
            text1x8field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 0, to: 6) {
            text1x7field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 0, to: 5) {
            text1x6field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 0, to: 4) {
            text1x5field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 0, to: 3) {
            text1x4field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 0, to: 2) {
            text1x3field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 0, to: 1) {
            text1x2field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 1, to: 9) {
            text2x10field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 1, to: 8) {
            text2x9field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 1, to: 7) {
            text2x8field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 1, to: 6) {
            text2x7field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 1, to: 5) {
            text2x6field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 1, to: 4) {
            text2x5field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 1, to: 3) {
            text2x4field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 1, to: 2) {
            text2x3field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 2, to: 9) {
            text3x10field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 2, to: 8) {
            text3x9field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 2, to: 7) {
            text3x8field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 2, to: 6) {
            text3x7field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 2, to: 5) {
            text3x6field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 2, to: 4) {
            text3x5field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 2, to: 3) {
            text3x4field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 3, to: 9) {
            text4x10field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 3, to: 8) {
            text4x9field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 3, to: 7) {
            text4x8field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 3, to: 6) {
            text4x7field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 3, to: 5) {
            text4x6field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 3, to: 4) {
            text4x5field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 4, to: 9) {
            text5x10field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 4, to: 8) {
            text5x9field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 4, to: 7) {
            text5x8field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 4, to: 6) {
            text5x7field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 4, to: 5) {
            text5x6field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 5, to: 9) {
            text6x10field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 5, to: 8) {
            text6x9field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 5, to: 7) {
            text6x8field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 5, to: 6) {
            text6x7field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 6, to: 9) {
            text7x10field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 6, to: 8) {
            text7x9field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 6, to: 7) {
            text7x8field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 7, to: 9) {
            text8x10field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 7, to: 8) {
            text8x9field.stringValue = "\(link.weight)"
        }
        
        if let link = findLink(in: links, from: 8, to: 9) {
            text9x10field.stringValue = "\(link.weight)"
        }
    }
    
    private func findLink(in links: [Link], from: Int, to: Int) -> Link? {
        return links.first(where: { link -> Bool in
            return (link.from.index == from && link.to.index == to) || (link.from.index == to && link.to.index == from)
        })
    }
}

