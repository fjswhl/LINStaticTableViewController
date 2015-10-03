//
//  StaticTableViewController.swift
//  StaticTableViewController
//
//  Created by Lin on 15/10/2.
//  Copyright © 2015年 Lin. All rights reserved.
//

import UIKit

struct TablViewCellItem {
    let cell: UITableViewCell
    let height: CGFloat
    var target: AnyObject?
    var action: Selector

    init(cell: UITableViewCell, height: CGFloat, target: AnyObject? = nil, action: Selector = nil) {
        self.cell = cell
        self.height = height
        self.target = target
        self.action = action
    }
}

func == (left: TablViewCellItem, right: TablViewCellItem) -> Bool {
    return left.cell == right.cell
}

class StaticTableViewController: UIViewController {

    let tableView: UITableView = UITableView(frame: CGRectZero, style: .Grouped)

    var cells: [[TablViewCellItem]] = [[TablViewCellItem]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Bottom, relatedBy: .Equal, toItem: bottomLayoutGuide, attribute: .Top, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0))
    }
}

extension StaticTableViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cells.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.section][indexPath.row].cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cells[indexPath.section][indexPath.row].height
    }
}

extension StaticTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = cells[indexPath.section][indexPath.row]
        guard let target = item.target else { return }
        if target.respondsToSelector(item.action) {
            target.performSelector(item.action, withObject: item.cell)
        }
    }
}

// Cell insertion and deletion
extension StaticTableViewController {

    func indexPathForCellItem(cellItem: TablViewCellItem) -> NSIndexPath? {
        for var section = 0; section < cells.count; section++ {
            for var row = 0; row < cells[section].count; row++ {
                if cells[section][row] == cellItem {
                    return NSIndexPath(forRow: row, inSection: section)
                }
            }
        }
        return nil
    }

    func insertCell(cellItem: TablViewCellItem, atIndexPath indexPath: NSIndexPath, withRowAnimation rowAnimation: UITableViewRowAnimation = .Automatic) {
        cells[indexPath.section].insert(cellItem, atIndex: indexPath.row)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: rowAnimation)
    }

    func insertCells(cellItems: [[TablViewCellItem]], atIndexpaths indexPaths: [NSIndexPath], withRowAnimation rowAnimation: UITableViewRowAnimation = .Automatic) {
        for indexPath in indexPaths {
            cells[indexPath.section].insert(cellItems[indexPath.section][indexPath.row], atIndex: indexPath.row)
        }
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: rowAnimation)
    }

    func deleteCellWithIndexPath(indexPath: NSIndexPath, withRowAnimation rowAnimation: UITableViewRowAnimation = .Automatic) {
        cells[indexPath.section].removeAtIndex(indexPath.row)
        if cells[indexPath.section].count == 0 {
            cells.removeAtIndex(indexPath.section)
        }
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: rowAnimation)
    }

    func moveRowAtIndexPath(indexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let fromCellItem = cells[indexPath.section][indexPath.row]
        if indexPath.section == toIndexPath.section {
            if indexPath.row < toIndexPath.row {
                cells[indexPath.section].insert(fromCellItem, atIndex: toIndexPath.row + 1)
                cells[indexPath.section].removeAtIndex(indexPath.row)
            } else if indexPath.row > toIndexPath.row {
                cells[indexPath.section].insert(fromCellItem, atIndex: toIndexPath.row)
                cells[indexPath.section].removeAtIndex(indexPath.row + 1)
            } else {
                return
            }
        } else {
            cells[toIndexPath.section].insert(fromCellItem, atIndex: toIndexPath.row)
            cells[indexPath.section].removeAtIndex(indexPath.row)
        }

        tableView.moveRowAtIndexPath(indexPath, toIndexPath: toIndexPath)
    }
}


