//
//  ImageIO.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/15/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

import Swiftilities
import UIKit.UIImage
import Utilities

enum ImageIO {

    struct CorruptedImageDataError: Error {}

    static func persistImage(_ image: UIImage, named name: String) {
        DispatchQueue.global(qos: .background).async {
            guard let imageData = image.pngData() else {
                Log.error("Could not generate PNG to save image: \(image)")
                return
            }

            let fullURL = urlForImage(named: name)

            do {
                try imageData.write(to: fullURL, options: [.atomic])
            }
            catch {
                Log.error("Error writing to file: \(error)")
            }
        }
    }

    static func loadPersistedImage(named name: String, completion: @escaping (Result<UIImage>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let imageURL = urlForImage(named: name)
            do {
                let imageData = try Data(contentsOf: imageURL)
                if let image = UIImage(data: imageData) {
                    completion(.success(image))
                }
                else {
                    completion(.failure(CorruptedImageDataError()))
                }
            }
            catch {
                Log.error("Error loading image from url: \(imageURL): \(error)")
                completion(.failure(error))
            }
        }
    }

}

private extension ImageIO {

    static func urlForImage(named name: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        let documentsURL = paths.first!

        let fullURL = documentsURL.appendingPathComponent(name).appendingPathExtension("png")
        return fullURL
    }

}
