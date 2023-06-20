//
//  MBRequest.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 19/06/2023.
//

import Foundation
import RxSwift

class MBRequest<Query: MBQuery> {
    private let query: Query

    private var task: URLSessionDataTask?

    private var request: URLRequest {
        guard var components = URLComponents(url: query.url, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        components.queryItems = query.allParameters.map {
            URLQueryItem(name: $0, value: String(describing: $1))
        }

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = query.method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    func send(completion: @escaping (Result<Query.ResultType, Error>) -> Void) {
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(MBError.noData))
                return
            }

            do {
                let value = try JSONDecoder().decode(Query.ResultType.self, from: data)
                completion(.success(value))
                return
            } catch {
                completion(.failure(error))
                return
            }
        }

        task?.resume()
    }

    func cancel() {
        task?.cancel()
    }

    init(query: Query) {
        self.query = query
    }
}

enum MBError: Error {
    case noData
}

extension MBRequest {
    func asObservable() -> Observable<Result<Query.ResultType, Error>> {
        Observable.create { observer in
            self.send { result in
                observer.onNext(result)
                observer.onCompleted()
            }
            return Disposables.create {
                self.cancel()
            }
        }
    }
}
