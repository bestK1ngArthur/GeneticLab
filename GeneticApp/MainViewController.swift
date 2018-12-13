//
//  MainViewController.swift
//  GeneticApp
//
//  Created by bestK1ng on 04/12/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    private let rowHeight: CGFloat = 23
    
    private var currentPopulation: Population?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        currentPopulation = Population.generatePopulation(for: Link.generateLinks(size: 10, range: 0..<10), from: Node(7), to: Node(5))
        
        tableView.reloadData()
    }
    
    func showPopulation(_ population: Population, in tableView: NSTableView) {
        
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
    
    private func getNode(from population: Population, tableColumn: Int, tableRow: Int) -> Node? {
     
        var node: Node?
        if tableRow == population.routes[tableColumn].links.count - 1 {
            node = population.routes[tableColumn].links[tableRow-1].to
        } else if tableRow < population.routes[tableColumn].links.count - 1  {
            node = population.routes[tableColumn].links[tableRow].from
        }
        
        return node
    }
}

