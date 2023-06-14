
import SwiftUI

struct AddEventSheet: View {
    @Binding var isPresented: Bool
    @Environment(\.dismiss) private var dismiss
    @State var selectedDate: Date?
    @State private var title: String = ""
    @State private var location: String = ""
    @State var image: UIImage = UIImage()
    @State private var review: String = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var todayEmotion: EmotionType = EmotionType.happy
    @State var openImageSelector: Bool = false
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
            TextField("여행 장소 추가", text: $location).font(.custom("Dovemayo_gothic", size: 20)).padding().keyboardType(.decimalPad).disableAutocorrection(true)
            Button {
                openImageSelector = true
            } label: {
                Text("이미지 추가").basicFont()
            }.sheet(isPresented: $openImageSelector) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
            }

            DatePicker(selection: $startDate, displayedComponents: .date) {
                Text("시작 날짜").font(.custom("Dovemayo_gothic", size: 20))
            }.padding()
            DatePicker(selection: $endDate, displayedComponents: .date) {
                Text("종료 날짜").font(.custom("Dovemayo_gothic", size: 20))
            }.padding()
            Picker("오늘의 기분은 어떠셨나요?", selection: $todayEmotion) {
                ForEach(EmotionType.allCases) {
                        Text($0.rawValue)
                }
            }.pickerStyle(.segmented)
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
            dateManager.eventList.append(Event(title: title, image: SomeImage(photo: image), expression: todayEmotion, startDate: startDate, endDate: startDay.addingTimeInterval(TimeInterval(86400*i))))
        }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(dateManager.eventList), forKey: "EVENT_DATA_KEY")
        return UserDefaults.standard.synchronize()
    }
}
