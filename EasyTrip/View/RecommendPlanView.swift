import SwiftUI
import ChatGPTSwift

struct RecommendPlanView: View {
    let manager = TripPlanner.shared
    @State var destination = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var budget = ""
    @State var person = ""
    @State var question = ""
    @State var respond = ""
    @State var idx = 0
    lazy var viewArr = [DestinationView, DateView] as [Any]
    var DestinationView:  some View {
        VStack {
            Spacer()
            Text("어디로 가세요?").font(.custom("Dovemayo_gothic", size: 30)).bold()
            TextField(text: $destination) {
                Text("여행 장소를 입력해주세요").basicFont()
            }.cornerRadius(15).font(.custom("Dovemayo_gothic", size: 20)).textFieldStyle(.roundedBorder).border(Color("Color 2")).disableAutocorrection(true)

            Text("추천").basicFont()
            HStack {
                ForEach(["베트남", "제주도", "파리", "일본"], id: \.self) { loc in
                    Button {
                        destination = loc
                    } label: {
                        Text(loc).basicFont().padding(5).background(Color("Color 2")).foregroundColor(.black)
                    }.cornerRadius(15)
                }
            }
            Spacer()
            Button {
                idx += 1
            } label: {
                Text("완료").basicFont().cornerRadius(15).foregroundColor(.black).frame(minWidth: 350, minHeight: 40).background(Color("Color 2"))
            }.cornerRadius(15)
        }.padding()
    }
    
    var DateView:  some View {
        VStack {
            Spacer()
            Text("언제 가세요?").font(.custom("Dovemayo_gothic", size: 30)).bold()
            DatePicker(selection: $startDate) {
                Text("시작 날짜").font(.custom("Dovemayo_gothic", size: 20))
            }.padding()
            DatePicker(selection: $endDate) {
                Text("종료 날짜").font(.custom("Dovemayo_gothic", size: 20))
            }.padding()
            Spacer()
            Button {
                idx += 1
            } label: {
                Text("완료").basicFont().cornerRadius(15).foregroundColor(.black).frame(minWidth: 350, minHeight: 40).background(Color("Color 2"))
            }.cornerRadius(15)
        }.padding()
    }
    
    var PersonView:  some View {
        VStack {
            Spacer()
            Text("누구랑 가세요?").font(.custom("Dovemayo_gothic", size: 30))
            TextField(text: $person) {
                Text("함께 여행가는 사람을 알려주세요").basicFont()
            }.cornerRadius(15).font(.custom("Dovemayo_gothic", size: 20)).textFieldStyle(.roundedBorder).border(Color("Color 2")).keyboardType(.decimalPad).disableAutocorrection(true)

            HStack {
                ForEach(PersonType.allCases, id: \.self) { type in
                    Button {
                        person = type.rawValue
                    } label: {
                        Text(type.rawValue).basicFont().padding(5).background(Color("Color 2")).foregroundColor(.black)
                    }.cornerRadius(15)
                }
            }
           
            Spacer()
            Button {
                idx += 1
            } label: {
                Text("완료").basicFont().cornerRadius(15).foregroundColor(.black).frame(minWidth: 350, minHeight: 40).background(Color("Color 2"))
            }.cornerRadius(15)
        }.padding()
    }
    
    var BudgetView:  some View {
        VStack {
            Spacer()
            Text("예산이 얼마정도 되나요?").font(.custom("Dovemayo_gothic", size: 30))
            TextField(text: $budget) {
                Text("예산을 입력해주세요").basicFont()
            }.cornerRadius(15).font(.custom("Dovemayo_gothic", size: 20)).textFieldStyle(.roundedBorder).border(Color("Color 2")).keyboardType(.decimalPad).disableAutocorrection(true)

            Spacer()
            Button {
                idx += 1
            } label: {
                Text("완료").basicFont().cornerRadius(15).foregroundColor(.black).frame(minWidth: 350, minHeight: 40).background(Color("Color 2"))
            }.cornerRadius(15)
        }.padding()
    }

    var AskView: some View {
        VStack {
            Text(destination)
            Text(df.string(from: startDate))
            Text(df.string(from: endDate))
            Text(person)
            Text(budget)
            
            Button {
                Task {
                    await sendToChatGPT("\(destination)에 \(df.string(from: startDate))에서 \(df.string(from: endDate))까지 \(person)랑 예산 \(budget)원으로 여행갈건데 여행 일정 표 형태로 그려줘")
                }
            } label: {
                Text("chatGPT에게 물어보기").basicFont()
            }
            
            Text(respond)

        }.padding()
    }
    var body: some View {
        switch idx {
            case 0 : DestinationView
            case 1 : DateView
            case 2 : PersonView
            case 3 : BudgetView
            default : AskView
        }
    }
//        VStack {
//            TextField(text: $question) {
//                Text("질문 입력").basicFont()
//            }.font(.custom("Dovemayo_gothic", size: 20))
//            Button {
//                Task {
//                    await sendToChatGPT(question)
//                }
//            } label: {
//                Text("chatGPT에게 물어보기").basicFont()
//            }
//            Text(respond)
//        }.padding()
    
    func sendToChatGPT(_ message: String) async {
        print("send To ChatGPT")
        let api = ChatGPTAPI(apiKey: "mykey")
        do {
            respond = try await api.sendMessage(text: message)
            print(message)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct RecommendPlanView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendPlanView()
    }
}
