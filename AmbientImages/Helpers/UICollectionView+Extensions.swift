//
//  UICollectionView+Extensions.swift
//  AmbientImages
//
//  Created by Christian Cieza on 21/09/21.
//

import UIKit

extension UICollectionReusableView {

    static var reuseID: String { String(describing: self) }

}

extension UICollectionView {

    func registerCell<Cell: UICollectionViewCell>(_: Cell.Type) {
        register(Cell.self, forCellWithReuseIdentifier: Cell.reuseID)
    }

    func registerdSupplementaryView<View: UICollectionReusableView>(_: View.Type, kind: SupplementaryViewKind) {
        register(View.self, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: View.reuseID)
    }

    func dequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.reuseID, for: indexPath) as? Cell else {
            fatalError("Error dequeuing \(Cell.reuseID)")
        }
        return cell
    }

    func dequeueReusableSupplementaryView<View: UICollectionReusableView>(
        ofKind kind: SupplementaryViewKind,
        for indexPath: IndexPath
    ) -> View {
        guard let view = dequeueReusableSupplementaryView(
                ofKind: kind.rawValue,
                withReuseIdentifier: View.reuseID,
                for: indexPath
        ) as? View else {
            fatalError("Error dequeuing \(View.reuseID)")
        }
        return view
    }

    enum SupplementaryViewKind: String {

        case header

    }

}
