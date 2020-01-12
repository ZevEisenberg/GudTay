//
//  SimpleTableCellItem.swift
//  GudTay
//
//  Created by ZevEisenberg on 10/26/17.
//  Copyright © 2017 ZevEisenberg. All rights reserved.
//

import UIKit

public struct SimpleTableCellItem {
    public typealias VoidBlock = () -> Void

    let text: String
    let selectCell: VoidBlock

    public init(text: String, selectCell: @escaping VoidBlock) {
        self.text = text
        self.selectCell = selectCell
    }
}

extension SimpleTableCellItem: TableViewCellRepresentable, CellIdentifiable {
    public static func register(_ tableView: UITableView) {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    public func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = text
        return cell
    }

    public func performSelection() {
        self.selectCell()
    }
    public func canSelect() -> Bool {
        true
    }
}
