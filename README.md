# EasyTrip ✈️
ChatGPT API를 활용한 똑똑한 여행 어플   
> **개발기한 (2023.05 ~ 진행중)** [Notion](https://www.notion.so/82cded2972354d9395efdaa4e97b0307?pvs=4)
##  프로젝트 소개 ⭐

### 주제
AI기반 여행 일정 추천 및 일기 어플 개발

### 주요 기능
- 1. ChatGPT API를 활용한 여행 계획 세우기
- 2. 사용자가 선택한 키워드로 여행 기록하기

## 구현 화면 📱
### 주요 화면
|메인 화면|여행 일기 캘린더|일정 추천 받기|
|---|---|---|
|<img src = "https://github.com/sumin305/EasyTrip/assets/110437548/4efe079f-d9c6-4339-ae8d-c38414bd9585" width = "500">|<img src = "https://github.com/sumin305/EasyTrip/assets/110437548/bb7ec747-20f6-4719-9fc6-cc9c60124c80" width = "500">|<img width="500" alt="image" src="https://github.com/sumin305/EasyTrip/assets/110437548/33b211d5-317a-4a97-a690-4a89b527be15">

## 도전 & 문제 해결 🔥
### SwiftUI
#### ⏺ 입력 뷰 여러개로 받기 
|Destination|Date|PersonType|Budget|Comfirmed|
|---|---|---|---|---|
|<img src = "https://github.com/sumin305/EasyTrip/assets/110437548/78eeba7a-0ff7-4ec3-8d93-b793d35a22d2" width = "240">|<img src = "https://github.com/sumin305/EasyTrip/assets/110437548/d42ef629-89d6-49dd-a66d-27ab4afa159a" width = "270">|<img src = "https://github.com/sumin305/EasyTrip/assets/110437548/42cf5323-9661-49ae-b1ee-48319a54563e" width = "240">|<img src = "https://github.com/sumin305/EasyTrip/assets/110437548/c9dc14d5-5d5e-4e4b-94ee-0e7e8e56ff6f" width = "270">|<img src = "https://github.com/sumin305/EasyTrip/assets/110437548/73b943d9-3d43-4b09-849b-304aff427aeb" width = "240">|

- Switch-Case문 활용하여 한 화면당 하나의 입력을 받기
- 뷰마다 index를 부여하여 다음 뷰로 이동할 때마다 index += 1   
- NavigationBarBackButton을 첫번째 화면과 마지막 화면을 제외하고는 없애서 전 화면으로 가기 버튼과의 혼돈을 없애기    
```swift
var body: some View {
        VStack {
            switch idx {
                case 0 :
                    DestinationView
                        .onAppear{
                            navigationBarBackButton = false
                        }.navigationBarBackButtonHidden(navigationBarBackButton)
                case 1 : DateView.onAppear{
                    navigationBarBackButton = true
                }.navigationBarBackButtonHidden(navigationBarBackButton)
                case 2 : PersonView.onAppear{
                    navigationBarBackButton = true
                }.navigationBarBackButtonHidden(navigationBarBackButton)
                case 3 : BudgetView.onAppear{
                    navigationBarBackButton = true
                }.navigationBarBackButtonHidden(navigationBarBackButton)
                case 4 : AskView.onAppear{
                    navigationBarBackButton = true
                }.navigationBarBackButtonHidden(navigationBarBackButton)
                default : RespondView.onAppear {
                    navigationBarBackButton = false
                }.navigationBarBackButtonHidden(navigationBarBackButton)
            }
            Text("\(idx+1)/6")
        }
    }
 ```
 
 #### ⏺ 일기 모델에 이미지 속성 추가
<img width="624" alt="image" src="https://github.com/sumin305/EasyTrip/assets/110437548/ddba8cc3-541e-4278-b5ff-c5e6aafa95c0">        


- Image와 UIImage 타입이 decodable protocol을 준수하지 않음!
- 일기 모델에는 이미지 속성이 필수적으로 필요하다고 판단하여 아래와 같은 커스텀 구조체 생성하여 에러 해결   
```swift
public struct SomeImage: Codable, Hashable {

    public let photo: Data
    
    public init(photo: UIImage) {
        self.photo = photo.pngData()!
    }
}
```  
```swift
// 이전의 에러가 사라짐
struct Event: Codable, Hashable {
    var title: String = ""
    var location: String = ""
    var image: SomeImage?
    var review: String = ""
    var expression: String = ""
    var startDate: Date
    var endDate: Date
}
```    
```swift
// 이미지 화면에 출력하기
if let img = event.image?.photo {
         Image(uiImage: UIImage(data: img)!).resizable().frame(width: 150, height: 150)
}
```

#### ⏺ FSCalendar 패키지 SwiftUI에서 사용하기
- UIViewRepresentable를 활용하여 SwiftUI에서 UIkit의 UIView를 사용
- UIView에서 선택한 날짜 데이터를 SwiftUI로 전달받는 것이 관건
- @State와 @Binding 프로퍼티 래퍼를 활용하여 해결
```swift
struct CalendarView: View {
    
    @State var selectedDate: Date?
    
    struct Calendar: UIViewRepresentable {
        
        @Binding var selectedDate: Date?
        typealias UIViewType = FSCalendar
        
        /// 생략 ///
            
        // 날짜 선택 시 콜백 메서드
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            selectedDate = date
            print(df.string(from: date))
        }
        // 날짜 선택 해제 시 콜백 메서드
        public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
            print(df.string(from: date))

        }
    }
        
    var body: some View {
        VStack(alignment: .center) {
                Calendar(selectedDate: $selectedDate).padding()
                }
      }
}
```
                    
