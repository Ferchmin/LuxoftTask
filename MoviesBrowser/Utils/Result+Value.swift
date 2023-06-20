//
//  Result+Value.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 20/06/2023.
//

import Foundation

extension Result {
    var value: Success? {
        switch self {
        case .success(let value): return value
        case .failure: return nil
        }
    }
}
