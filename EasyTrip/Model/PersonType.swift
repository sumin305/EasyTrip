import Foundation

enum PersonType: String, Identifiable, CaseIterable {
    case friend = "친구"
    case parent = "부모님"
    case family = "가족"
    case lover = "애인"
    case colleague = "직장 동료"
    var id: String {self.rawValue}
}
