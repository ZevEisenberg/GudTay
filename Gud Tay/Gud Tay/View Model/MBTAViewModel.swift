//
//  MBTAViewModel.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 7/25/16.
//  Copyright © 2016 Zev Eisenberg. All rights reserved.
//

import Foundation

final class MBTAViewModel {

    enum Result {

        case success(Stop)
        case failure(MBTAViewModel.RefreshError)

    }

    enum RefreshError: Error {

        case jsonWasNil
        case networkError(NSError)
        case jsonError(JSONError)
        case genericError(Error)

    }

    private let serviceType: MBTAServiceType.Type

    init(serviceType: MBTAServiceType.Type) {
        self.serviceType = serviceType
    }

    func refresh(_ completion: (Result) -> ()) {
        self.serviceType.predictionsByStop(stopId: "place-sull") { apiResult in
            switch apiResult {
            case .success(let jsonObject):
                guard let jsons = jsonObject else {
                    completion(.failure(.jsonWasNil))
                    return
                }

                do {
                    let sullivan = try Stop(json: jsons)
                    completion(.success(sullivan))
                }
                catch let jsonError as JSONError {
                    completion(.failure(.jsonError(jsonError)))
                }
                catch let genericError {
                    completion(.failure(.genericError(genericError)))
                }
            case .failure(let networkError):
                completion(.failure(.networkError(networkError)))
            }
        }
    }

}
