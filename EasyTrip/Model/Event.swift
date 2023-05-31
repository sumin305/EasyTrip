import Foundation
import SwiftUI

struct Event: Codable, Hashable {
    var title: String = ""
    var location: String = ""
    var image: SomeImage?
    var review: String = ""
    var expression: String = ""
    var startDate: Date
    var endDate: Date
}

public struct SomeImage: Codable, Hashable {

    public let photo: Data
    
    public init(photo: UIImage) {
        self.photo = photo.pngData()!
    }
}
