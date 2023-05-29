import SwiftUI
import FSCalendar
struct CalendarView: View {
    
    @State var selectedDate: Date?
    @StateObject private var dateManager = EventManager.shared
    @State var isShowSheet: Bool = false
    @State var isShowAlert: Bool = false
    
    struct Calendar: UIViewRepresentable {
        
        @Binding var selectedDate: Date?
        typealias UIViewType = FSCalendar
        
        func makeUIView(context: Context) -> FSCalendar {
            let calendar = FSCalendar()
            calendar.delegate = context.coordinator
            calendar.dataSource = context.coordinator
            calendar.scope = .month  // 월간
            //calendar.locale = Locale(identifier: "ko_KR")
            
            // 헤더 폰트 설정
            calendar.appearance.headerTitleFont = UIFont(name: "Dovemayo_gothic", size: 30)
            calendar.appearance.headerTitleColor = UIColor(named: "Color 1")
            // 헤더의 날짜 포맷 설정
            calendar.appearance.headerDateFormat = "M월"
            calendar.appearance.headerTitleAlignment = .center
            calendar.headerHeight = 50
            // 헤더 양 옆(전달 & 다음 달) 글씨 투명도
            calendar.appearance.headerMinimumDissolvedAlpha = 0.0   // 0.0 = 안보이게
            
            // Weekday 폰트 설정
            calendar.appearance.weekdayFont = UIFont(name: "Dovemayo_gothic", size: 20)
            //calendar.appearance.todaySelectionColor = UIColor(named: "Color 1")
            calendar.appearance.weekdayTextColor = UIColor.black
            
            
            // 각각의 일(날짜) 폰트 설정 (ex. 1 2 3 4 5 6 ...)
            calendar.appearance.titleFont = UIFont(name: "Dovemayo_gothic", size: 20)
            calendar.appearance.selectionColor = UIColor(named: "Color 2")
            calendar.appearance.todayColor = UIColor.gray
            
            // 이벤트 색상 변경
            calendar.appearance.eventDefaultColor = UIColor(named: "Color 2")
            calendar.appearance.eventSelectionColor = UIColor(named: "Color 5")
            
            // 날짜 선택
            //calendar.allowsMultipleSelection = true
            calendar.swipeToChooseGesture.isEnabled = true
            calendar.appearance.titleDefaultColor = .black  // 평일
            calendar.appearance.titleWeekendColor = UIColor(named: "Color 5")    // 주말
            
            calendar.placeholderType = .fillHeadTail
            calendar.swipeToChooseGesture.isEnabled = true
            
            return calendar
        }
        // 날짜 선택 시 콜백 메소드
        func updateUIView(_ uiView: FSCalendar, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(selectedDate: $selectedDate)
        }
        
        class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
            @Binding var selectedDate: Date?
            
            init(selectedDate: Binding<Date?>) {
                _selectedDate = selectedDate
            }
            func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
                selectedDate = date
                print(df.string(from: date))
            }
            // 날짜 선택 해제 시 콜백 메소드
            public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
                print(df.string(from: date))
                
            }
        }
    }
    var body: some View {
        ZStack {
            Color("Color 3").ignoresSafeArea(.all)
            VStack(alignment: .center) {
                ZStack {
                    Color.white.ignoresSafeArea().cornerRadius(20)
                    Calendar(selectedDate: $selectedDate).padding()
                    HStack {
                        Spacer()
                        VStack {
                            Button {
                                isShowSheet = true
                            } label: {
                                Image(systemName: "plus").font(.system(size: 30)).padding()
                            }.sheet(isPresented: self.$isShowSheet) {
                                AddEventSheet(isPresented: self.$isShowSheet,
                                              selectedDate:
                                                selectedDate ?? Date())
                            }.alert(isPresented: $isShowAlert) {
                                Alert(title: Text("알림"), message: Text("날짜를 선택해주세요"), dismissButton: .default(Text("확인")))
                            }
                            Spacer()
                        }
                    }
                }.padding()
                VStack(alignment: .leading) {
                    Text(df.string(from: selectedDate ?? Date())).basicFont()
                    List {
                        ScrollView {
                            ForEach(dateManager.eventList, id: \.self) { event in
                                if selectedDate == event.startDate {
                                    Text(event.title).basicFont()
                                }
                            }
                        }
                        
                    }.listStyle(DefaultListStyle()).cornerRadius(20)
                }.padding().frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: 250
                )
            }
        }
    }
}
extension Text {
    func basicFont() -> Text{
        return self.font(.custom("Dovemayo_gothic", size: 20))
    }
}


func setEvent(_ date: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let str = dateFormatter.string(from: date)
    let event = dateFormatter.date(from: str)
    print(event)
    
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
