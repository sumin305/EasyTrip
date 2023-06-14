import Foundation

enum EmotionType: String, CaseIterable, Identifiable, Codable {
    var id: Self {
        return self
    }
    case happy = "😁"
    case sad = "😭"
    case angry = "😡"
    case comfortable = "🙃"
    case embarrassed = "😲"
}
