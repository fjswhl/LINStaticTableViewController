//
//  TableViewController.swift
//  LINStaticTableViewController
//
//  Created by Lin on 15/10/2.
//  Copyright © 2015年 Lin. All rights reserved.
//

import UIKit

class TableViewController: StaticTableViewController {

    let cell1: UITableViewCell = {
        let c = UITableViewCell()
        c.textLabel?.text = "cell1"
        return c
        }()

    let cell2: UITableViewCell = {
        let c = UITableViewCell()
        c.textLabel?.text = "cell2"
        return c
        }()

    let cell3: UITableViewCell = {
        let c = UITableViewCell()
        c.textLabel?.text = "cell3"
        return c
        }()


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add")
        cells.append([TablViewCellItem(cell: cell1, height: 44),
                      TablViewCellItem(cell: cell2, height: 44),
                      TablViewCellItem(cell: cell3, height: 44)])

    }

    var count = 10
    func add() {
        moveRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), toIndexPath: NSIndexPath(forRow: 2, inSection: 0))
//        let cell = UITableViewCell()
//        cell.textLabel?.text = "cell\(count)"
//        count++
////        cells[0].append(TablViewCellItem(cell: cell, height: 44))
////        tableView.reloadData()
//        insertCell(TablViewCellItem(cell: cell, height: 44), atIndexPath: NSIndexPath(forRow: 2, inSection: 0))
    }
}
