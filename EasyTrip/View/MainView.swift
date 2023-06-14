import SwiftUI

struct MainView: View {
    
    @StateObject private var dateManager = EventManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Easy Trip✈️").font(.custom("Dovemayo_gothic", size: 40))
                Text("AI와 함께 여행을 계획하고 기록하세요!").font(.custom("Dovemayo_gothic", size: 20)).foregroundColor(.gray)
                Group {
                    Divider()
                    HStack {
                        NavigationLink {
                            RecommendPlanView()
                        } label: {
                            VStack {
                                Spacer()
                                Text("일정짜기").font(.custom("Dovemayo_gothic", size: 25)).foregroundColor(.black)
                                Spacer()
                                Text("AI가 일정을 추천해줘요!\n").font(.custom("Dovemayo_gothic", size: 15)).foregroundColor(.gray).padding(5)
                            }.frame(width: 150, height: 150)
                                .background(Color("Color 4"))
                        }.cornerRadius(10).padding(5)
                        
                        NavigationLink {
                            CalendarView()
                        } label: {
                            VStack {
                                Spacer()
                                Text("일기쓰기").font(.custom("Dovemayo_gothic", size: 25))
                                    .foregroundColor(.black)
                                Spacer()
                                Text("내가 쓴 일기를 AI가 감정 스티커로 만들어줘요!").font(.custom("Dovemayo_gothic", size: 15))
                                    .foregroundColor(.gray).padding(5)
                            } .frame(width: 150, height: 150)
                                .cornerRadius(20)
                                .background(Color("Color 4"))
                        }.cornerRadius(10).padding(5)
                    }.padding()
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("My Story").font(.custom("Dovemayo_gothic", size: 20))
                        VStack {
                            if dateManager.eventList.isEmpty {
                                VStack {
                                    Text("아직 기록이 없네요 😢").basicFont()
                                    NavigationLink {
                                        CalendarView()
                                    } label: {
                                        Text("여행 일기 작성하러 가기").basicFont()
                                            .foregroundColor(.gray)
                                    }
                                }
                            } else {
                                ScrollView(.horizontal) {
                                    HStack(alignment: .top) {
                                        ForEach(dateManager.eventList, id: \.self) { event in
                                            VStack {
                                                Text("\(df.string(from: event.startDate)) ~ \(df.string(from: event.endDate))")
                                                    .basicFont()
                                                if let img = event.image?.photo {
                                                    Image(uiImage: UIImage(data: img)!).resizable().frame(width: 150, height: 150)
                                                }
                                                
                                                Text("\(event.title)").basicFont()
                                            }.padding().frame(minWidth: 100, minHeight: 200).background(Color(.white)).cornerRadius(15)
                                        }
                                    }.padding()
                                    
                                }
                            }
                        }.frame(minWidth: 250, maxWidth: 350, minHeight: 200).background(Color("Color 3")).cornerRadius(15)
                    }
                }
            }
        }.ignoresSafeArea(.all)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
