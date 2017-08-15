//
//  ImageIO.swift
//  Gud Tay
//
//  Created by Zev Eisenberg on 8/15/17.
//  Copyright © 2017 Zev Eisenberg. All rights reserved.
//

import UIKit.UIImage

struct ImageIO {

    static func persistImage(_ image: UIImage, named name: String) {
        DispatchQueue.global(qos: .background).async {
            guard let imageData = UIImagePNGRepresentation(image) else {
                LogService.add(message: "Could not generate PNG to save image: \(image)")
                return
            }

            let fullURL = urlForImage(named: name)

            do {
                try imageData.write(to: fullURL, options: [.atomic])
            }
            catch {
                LogService.add(message: "Error writing to file: \(error)")
            }
        }
    }

    static func loadPersistedImage(named name: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let imageURL = urlForImage(named: name)

            do {
                let imageData = try Data(contentsOf: imageURL)
                let image = UIImage(data: imageData)
                completion(image)
            }
            catch {
                LogService.add(message: "Error loading image from url: \(imageURL): \(error)")
                completion(nil)
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
