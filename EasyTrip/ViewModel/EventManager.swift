import Foundation

class EventManager: ObservableObject {
    static let shared = EventManager()
    static let EVENT_DATA_KEY = "EVENT_DATA_KEY"
    @Published var eventList: [Event] = []
    
    init() {
        if let data = UserDefaults.standard.value(forKey: EventManager.EVENT_DATA_KEY) as? Data {
            let dataList = try? PropertyListDecoder().decode([Event].self, from: data)
            if let list = dataList {
                eventList = list
            }
        }
    }
    
    func addEvent(_ event: Event) -> [Event] {
        self.eventList.append(event)
        return eventList
    }
}
