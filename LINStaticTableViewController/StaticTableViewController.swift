//
//  StaticTableViewController.swift
//  StaticTableViewController
//
//  Created by Lin on 15/10/2.
//  Copyright © 2015年 Lin. All rights reserved.
//

import UIKit

// MARK: TableView Components
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

struct TableViewSectionItem {
    var cells: [TablViewCellItem] = [TablViewCellItem]()

    var headerTitle: String? = nil
    var headerHeight: CGFloat = 0

    var footerTitle: String? = nil
    var footerHeight: CGFloat = 0

    var headerView: UIView? = nil
    var footerView: UIView? = nil

    mutating func appendCellItem(cellItem: TablViewCellItem) {
        cells.append(cellItem)
    }

    mutating func appendCellItems(cellItems: [TablViewCellItem]) {
        cells.appendContentsOf(cellItems)
    }

    func cellCount() -> Int {
        return cells.count
    }

    func cellItemForRow(row: Int) -> TablViewCellItem {
        return cells[row]
    }

    func cellForRow(row: Int) -> UITableViewCell {
        return cells[row].cell
    }

    func heightForRow(row: Int) -> CGFloat {
        return cells[row].height
    }

    mutating func insertCellItem(item: TablViewCellItem, atIndex index: Int) {
        cells.insert(item, atIndex: index)
    }

    mutating func removeCellItemAtIndex(index: Int) {
        cells.removeAtIndex(index)
    }
}

// MARK: StaticTableViewController
class StaticTableViewController: UIViewController {

    let tableView: UITableView = UITableView(frame: CGRectZero, style: .Grouped)

    var sections: [TableViewSectionItem] = [TableViewSectionItem]()

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

    func setupWithSections(sections: [TableViewSectionItem]) {
        self.sections.appendContentsOf(sections)
    }
}

// MARK: UITableViewDataSource
extension StaticTableViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cellCount()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return sections[indexPath.section].cellForRow(indexPath.row)
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }

    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }
}

// MARK: UITableViewDelegate
extension StaticTableViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return sections[indexPath.section].heightForRow(indexPath.row)
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sections[section].headerHeight
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].footerHeight
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = sections[indexPath.row].cellItemForRow(indexPath.row)
        guard let target = item.target else { return }
        if target.respondsToSelector(item.action) {
            target.performSelector(item.action, withObject: item.cell)
        }
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].headerView
    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections[section].footerView
    }
}

// MARK: Cell insertion and deletion
extension StaticTableViewController {

    func indexPathForCellItem(cellItem: TablViewCellItem) -> NSIndexPath? {
        for var section = 0; section < sections.count; section++ {
            for var row = 0; row < sections[section].cells.count; row++ {
                if sections[section].cellItemForRow(row) == cellItem {
                    return NSIndexPath(forRow: row, inSection: section)
                }
            }
        }
        return nil
    }

    func insertCell(cellItem: TablViewCellItem, atIndexPath indexPath: NSIndexPath, withRowAnimation rowAnimation: UITableViewRowAnimation = .Automatic) {
        sections[indexPath.section].insertCellItem(cellItem, atIndex: indexPath.row)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: rowAnimation)
    }

    func deleteCellWithIndexPath(indexPath: NSIndexPath, withRowAnimation rowAnimation: UITableViewRowAnimation = .Automatic) {
        sections[indexPath.section].removeCellItemAtIndex(indexPath.row)
        if sections[indexPath.section].cellCount() == 0 {
            sections.removeAtIndex(indexPath.section)
        }
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: rowAnimation)
    }

    func moveRowAtIndexPath(indexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let fromCellItem = sections[indexPath.section].cellItemForRow(indexPath.row)
        if indexPath.section == toIndexPath.section {
            if indexPath.row < toIndexPath.row {
                sections[indexPath.section].insertCellItem(fromCellItem, atIndex: toIndexPath.row + 1)
                sections[indexPath.section].removeCellItemAtIndex(indexPath.row)
            } else if indexPath.row > toIndexPath.row {
                sections[indexPath.section].insertCellItem(fromCellItem, atIndex: toIndexPath.row)
                sections[indexPath.section].removeCellItemAtIndex(indexPath.row + 1)
            } else {
                return
            }
        } else {
            sections[toIndexPath.section].insertCellItem(fromCellItem, atIndex: toIndexPath.row)
            sections[indexPath.section].removeCellItemAtIndex(indexPath.row)
        }

        tableView.moveRowAtIndexPath(indexPath, toIndexPath: toIndexPath)
    }
}


