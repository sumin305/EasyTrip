
import SwiftUI

struct AddEventSheet: View {
    @Binding var isPresented: Bool
    @Environment(\.dismiss) private var dismiss
    @State var selectedDate: Date?
    @State private var title: String = ""
    @State private var review: String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @StateObject private var dateManager = EventManager.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Button {
                    dismiss()
                } label: {
                    Text("취소").basicFont()
                }
                Spacer()
                Button {
                    let interval = endDate.timeIntervalSince(startDate)
                    let days = Int(interval / 86400)
                    appendEvent(startDay: startDate, intervalDay: days, title: title)
                    dismiss()
                    print(dateManager.eventList)
                } label: {
                    Text("저장").basicFont()
                }
            }.padding()
            TextField("제목 추가", text: $title).font(.custom("Dovemayo_gothic", size: 20)).padding().keyboardType(.decimalPad).disableAutocorrection(true)
            DatePicker(selection: $startDate) {
                Text("시작 날짜").font(.custom("Dovemayo_gothic", size: 20))
            }.padding()
            DatePicker(selection: $endDate) {
                Text("종료 날짜").font(.custom("Dovemayo_gothic", size: 20))
            }.padding()
            TextField("리뷰", text: $review).font(.custom("Dovemayo_gothic", size: 20)).padding().keyboardType(.decimalPad).disableAutocorrection(true)
            Spacer()
        }.padding().onAppear {
            if let date = selectedDate {
                startDate = date
                endDate = date
            }
        }
    }
    
    func appendEvent(startDay: Date, intervalDay: Int, title: String) -> Bool {
        for i in 0...intervalDay {
            dateManager.eventList.append(Event(title: title, startDate: startDate, endDate: startDay.addingTimeInterval(TimeInterval(86400*i))))
        }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(dateManager.eventList), forKey: "EVENT_DATA_KEY")
        return UserDefaults.standard.synchronize()
    }
}
