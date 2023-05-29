
import SwiftUI

struct MainView: View {
    
    @StateObject private var dateManager = EventManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Easy Trip").font(.custom("Dovemayo_gothic", size: 40))
                Text("AI와 함께 여행을 계획하고 기록하세요!").font(.custom("Dovemayo_gothic", size: 20)).foregroundColor(.gray)

                HStack {
                    NavigationLink {
                        RecommendPlanView()
                    } label: {
                        Text("여행 일정\n 추천받기").basicFont()
                            .foregroundColor(.black)
                            .frame(width: 150, height: 150)
                            
                            .background(Color("Color 2"))
                    }.cornerRadius(15).padding()
                    
                    NavigationLink {
                        CalendarView()
                    } label: {
                        Text("여행 일기\n 작성하기").basicFont()
                            .foregroundColor(.black)
                            .frame(width: 150, height: 150)
                            .cornerRadius(20)
                            .background(Color("Color 2"))
                    }.cornerRadius(15).padding()
                }

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
                                            Text("\(event.title)").basicFont()
                                        }.padding().frame(minWidth: 100, minHeight: 150).background(Color(.white)).cornerRadius(15)
                                    }
                                }.padding()

                            }
                        }
                    }.frame(minWidth: 250, maxWidth: 350, minHeight: 200).background(Color("Color 3")).cornerRadius(15)
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
