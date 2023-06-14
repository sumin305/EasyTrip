import SwiftUI
import ChatGPTSwift

struct RecommendPlanView: View {
    let manager = TripPlanner.shared
    @State var destination = ""
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var budget = 0
    @State var person = ""
    @State var question = ""
    @State var respond = ""
    @State var tableRespond : [[String]] = []
    @State var idx = 0
    @State var loading = false
    @State var alert = false
    // DestinationView에서는 백버튼 보이게, 나머지 뷰에서는 이전 idx로 가능 버튼 보이도록.
    @State var navigationBarBackButton = true
    
    // 숫자 천 단위로 입력받을 때 , 표시
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
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
            DatePicker(selection: $startDate,  displayedComponents: .date) {
                Text("시작 날짜").font(.custom("Dovemayo_gothic", size: 20))
            }.padding()
            DatePicker(selection: $endDate, displayedComponents: .date) {
                Text("종료 날짜").font(.custom("Dovemayo_gothic", size: 20))
            }.padding()
            Spacer()
            Button {
                idx -= 1
            } label: {
                Text("이전으로").font(.custom("Dovemayo_gothic", size: 15)).bold()
            }
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
                idx -= 1
            } label: {
                Text("이전으로").font(.custom("Dovemayo_gothic", size: 15)).bold()
            }
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
            TextField(value: $budget, formatter: formatter) {
                Text(formatter.string(from: budget as! NSNumber)!)
            }.cornerRadius(15).font(.custom("Dovemayo_gothic", size: 20)).textFieldStyle(.roundedBorder).border(Color("Color 2")).keyboardType(.decimalPad).disableAutocorrection(true)
                

            Spacer()
            Button {
                idx -= 1
            } label: {
                Text("이전으로").font(.custom("Dovemayo_gothic", size: 15)).bold()
            }
            Button {
                idx += 1
            } label: {
                Text("완료").basicFont().cornerRadius(15).foregroundColor(.black).frame(minWidth: 350, minHeight: 40).background(Color("Color 2"))
            }.cornerRadius(15)

        }.padding()
    }

    var AskView: some View {
        VStack {
            Spacer()
            Text(destination + "으로").basicFont()
            Text(df.string(from: startDate) + " ~ " + df.string(from: endDate) + "까지").basicFont()
            Text("\(person)\((person == PersonType.colleague.rawValue || person == PersonType.friend.rawValue) ? "와" : "과")").basicFont()
            Text("예산 " + formatter.string(from: budget as! NSNumber)! + " 원으로").basicFont()
            Text("여행 가시나요 ?").basicFont()
            
            Spacer()
            Button {
                idx += 1
                Task {
                    await sendToChatGPT("\(destination)에 \(df.string(from: startDate))에서 \(df.string(from: endDate))까지 \(person)랑 예산 \(budget)원으로 여행갈건데 여행 일정 표 형태로 구체적으로 그려줘")
                }
                loading = true
            } label: {
                Text("여행 계획 세우기").basicFont()
            }
            
            
            Spacer()
            Button {
                idx -= 1
            } label: {
                Text("이전으로").font(.custom("Dovemayo_gothic", size: 15)).bold()
            }


        }.padding()
    }
    var RespondView: some View {
        
        VStack {
            Spacer()
            if loading {
                VStack {
                    ActivityIndicator(isAnimating: loading)
                        .configure{$0.color = UIColor.black}
                        .padding()
                        .cornerRadius(100)
                    Text(".")
                }
            } else {
                List {
                    ForEach(tableRespond, id: \.self) { text in
                        HStack {
                            ForEach(text, id: \.self) { t in
                                
                                if let num = Int(t) {
                                    Text(formatter.string(from: Int(t)! as! NSNumber)!).font(.custom("Dovemayo_gothic", size: 15)).padding()
                                } else {
                                    Text(t).font(.custom("Dovemayo_gothic", size: 15)).padding()
                                }
                                
                            }
                        }
                    }
                }
            }
            Spacer()
        }
    }
    
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
                        .alert("ChatGPT 시간초과", isPresented: $alert) {
                            Button("시간 초과") {
                                idx -= 1
                            }
                        }
            }
            Text("\(idx+1)/6")
        }
 
    }
    
    func sendToChatGPT(_ message: String) async {
        print("send To ChatGPT")
        let api = ChatGPTAPI(apiKey: ".")
        do {
            
            respond = try await api.sendMessage(text: message)
            print(respond)
            makeTable(respond)
            
        } catch {
            print(error.localizedDescription)
            loading = false
            alert = true
        }
    }
    
    func makeTable(_ str: String) {
        var strArr: [String] = str.split(separator: "\n").map{String($0)}
        
        for i in 0..<strArr.count {
            
            if strArr[i].contains("---") {
                continue
            }
            tableRespond.append(strArr[i].split(separator: "|").map{String($0)})
        }
        loading = false
    }
    
}

struct RecommendPlanView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendPlanView()
    }
}

struct ActivityIndicator: UIViewRepresentable {
    
    typealias UIView = UIActivityIndicatorView
    var isAnimating: Bool
    fileprivate var configuration = { (indicator: UIView) in }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView { UIView() }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
}
extension View where Self == ActivityIndicator {
    func configure(_ configuration: @escaping (Self.UIView)->Void) -> Self {
        Self.init(isAnimating: self.isAnimating, configuration: configuration)
    }
}
