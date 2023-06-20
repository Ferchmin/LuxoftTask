//
//  Storyboard.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 19/06/2023.
//

import UIKit

protocol Storyboard {
    associatedtype InitialControllerType: UIViewController
    static func instantiate() -> InitialControllerType
}

extension Storyboard {
    private static var name: String { String(describing: self) }

    static func instantiate() -> InitialControllerType {
        let storyboard = UIStoryboard(name: Self.name, bundle: Bundle.main)
        // swiftlint:disable force_cast
        return storyboard.instantiateInitialViewController() as! InitialControllerType
    }
}
