//
//  DebugMenuViewController.swift
//  GudTay
//
//  Created by ZevEisenberg on 10/26/17.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import Foundation
import Services

class DebugMenuViewController: UITableViewController {
    lazy var dataSource: TableDataSource = { [weak self] in
        let dataSource = TableDataSource(rows: [
        SimpleTableCellItem(text: "Text Styles") {
            self?.navigationController?.pushViewController(DebugTextStyleViewController(), animated: true)
        },
        ])
        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        SimpleTableCellItem.register(tableView)
        tableView.dataSource = dataSource
        addBehaviors([ModalDismissBehavior()])
        var title = "Debug Menu"
        if let dictionary = Bundle.main.infoDictionary,
            let version = dictionary["CFBundleShortVersionString"] as? String,
            let build = dictionary["CFBundleVersion"] as? String {
            title.append(" \(version) (\(build))")
        }
        self.title = title
    }
}

extension DebugMenuViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource[indexPath].performSelection()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
