//
//  MBImageResolver.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 19/06/2023.
//

import Foundation
import UIKit
import RxSwift

struct MBImageResolver {
    private let url: URL
    private let parameters = ["api_key": Config.apiKey]
    private var dataTask: URLSessionDataTask?

    private var request: URLRequest {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        components.queryItems = parameters.map {
            URLQueryItem(name: $0, value: String(describing: $1))
        }

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        return URLRequest(url: url)
    }

    private func storeImage(url: URL, image: UIImage?) {
        let path = NSTemporaryDirectory().appending(UUID().uuidString)
        let pathUrl = URL(fileURLWithPath: path)

        let data = image?.jpegData(compressionQuality: 1)
        try? data?.write(to: pathUrl)

        var dict = (UserDefaults.standard.object(forKey: "ImageCache")) as? [String: String] ?? [:]

        dict[url.absoluteString] = path
        UserDefaults.standard.setValue(dict, forKey: "ImageCache")
    }

    func getImage(completion: @escaping (UIImage?) -> Void) {
        if let dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String: String] {
            if let path = dict[url.absoluteString] {
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                    if let image = UIImage(data: data) {
                        completion(image)
                        return
                    }
                }
            }
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    storeImage(url: url, image: image)
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }
        .resume()
    }

    func cancel() {
        dataTask?.cancel()
    }

    init(url: URL) {
        self.url = url
    }
}

extension MBImageResolver {
    func asObservable() -> Observable<UIImage?> {
        Observable.create { observer in
            self.getImage { image in
                observer.onNext(image)
                observer.onCompleted()
            }
            return Disposables.create {
                self.cancel()
            }
        }
    }
}

