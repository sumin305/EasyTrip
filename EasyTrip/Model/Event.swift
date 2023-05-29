import Foundation
import SwiftUI

struct Event: Codable, Hashable {
    var title: String = ""
    var location: String = ""
    var review: String = ""
    var expression: String = ""
    var startDate: Date
    var endDate: Date
}
