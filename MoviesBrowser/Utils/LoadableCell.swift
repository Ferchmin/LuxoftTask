//
//  LoadableCell.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 19/06/2023.
//

import Foundation
import UIKit

protocol LoadableCell {
    static var cellIdentifier: String { get }
}

extension LoadableCell {
    static var cellIdentifier: String { String(describing: self) }
    var reuseIdentifier: String { Self.cellIdentifier }
}
