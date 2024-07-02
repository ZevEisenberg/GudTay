//
//  TableCellItem.swift
//  GudTay
//
//  Created by ZevEisenberg on 7/10/17.
//
//

import UIKit

public struct TableCellItem<View: UIView> {
    public typealias VoidBlock = () -> Void

    let make: () -> View
    let configure: (View) -> Void
    let configureCell: (TableViewContainerCell<View>) -> Void
    let selectCell: VoidBlock?

    public init(make: @escaping () -> View = { View() },
                configure: @escaping (View) -> Void = { _ in },
                configureCell: @escaping (TableViewContainerCell<View>) -> Void = { _ in },
                selectCell: VoidBlock? = nil) {
        self.make = make
        self.configure = configure
        self.configureCell = configureCell
        self.selectCell = selectCell
    }
}

extension TableCellItem: ViewRepresentable {
    public func makeView() -> View {
        make()
    }
    public func configure(view: View) {
        configure(view)
    }
}

extension TableCellItem: CellIdentifiable {
    public static var reuseIdentifier: String {
        "Default-\(self)-\(View.self)"
    }
}

extension TableCellItem: TableViewCellRepresentable {
    public func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueConfiguredCell(for: tableView, at: indexPath)
        configureCell(cell)
        return cell
    }

    public func canSelect() -> Bool {
        selectCell != nil
    }

    public func performSelection() {
        selectCell?()
    }
}
