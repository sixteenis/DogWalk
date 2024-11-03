//
//  ChattingRoomView.swift
//  DogWalk
//
//  Created by 박성민 on 10/31/24.
//

import SwiftUI

struct ChattingRoomView: View {
    private static let width = UIScreen.main.bounds.width
    private static var height = UIScreen.main.bounds.height
    @State private var bottomPadding: CGFloat = 0.0
    @State private var showKeyboard = false
    @State private var text: String = "" //임시 키보드 입력
    @State private var message = Message() // 임시 채팅 내역
    @State private var sendTest = false
}

extension ChattingRoomView {
    var body: some View {
        VStack {
            GeometryReader {
                //채팅부분
                ChatView(size: $0.size)
                    .onTapGesture {
                        self.dismissKeyboard()
                        showKeyboard = false
                    }
                // TODO: 키보드가 없어질때 자연스러운 조절을 위해 CommonSendView에 해당 이벤트 전달해주기
                //키보드
                CommonSendView(
                    proxy: $0,
                    yOffset: $bottomPadding,
                    showKeyboard: $showKeyboard
                ) { text in
                    print(text) // 보낼 경우 텍스트 반환
                    message.addMessage(text: text)
                }
            }
        }  //:VSTACK
        .ignoresSafeArea()
        .background(Color.primaryWhite)
        .padding(.top, 1.0)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        
    }
    
    
}

// MARK: - 채팅 내역 부분
private extension ChattingRoomView {
    @ViewBuilder
    func ChatView(size: CGSize) -> some View {
        ScrollViewReader { scroll in
            ScrollView {
                LazyVStack(spacing: 2.0) {
                    ForEach(message.modles) { model in
                        MessageView(size: size, model: model)
                            .padding(.bottom, 10)
                    }
                } //:VSTACK
                .onAppear {
                    //마지막 채팅 내역으로 스크롤 이동
                    scroll.scrollTo(message.modles.last?.id, anchor: .top)
                }
                .onChange(of: showKeyboard) { oldValue, newValue in //키보드 감지
                    guard newValue else { return }
                    //자연스러운 스크롤 구현
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation {
                            scroll.scrollTo(message.modles.last?.id, anchor: .top)
                        }
                    }
                    
                }
                .onChange(of: message) { oldValue, newValue in //새로운 메시지 감지
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation {
                            scroll.scrollTo(message.modles.last?.id, anchor: .top)
                        }
                    }
                }//새로운 데이터가 들어올 경우 스크롤 위치 하단으로
            } //:SCROLL
            .scrollIndicators(.hidden) //스크롤 Indicators 숨김
            .padding(.trailing) //자신도 프로필이 있을경유 horizontal으로 변경해주기
            .padding(.leading, 5)
            .padding(.bottom, bottomPadding)
        }
    }
}
// MARK: - 말풍선 부분
private extension ChattingRoomView {
    @ViewBuilder
    func MessageView(size: CGSize, model: MessageModel) -> some View {
        let isRight = model.userID == "나" //userID 변경해주기
        //말풍선 size 지정
        let minBubbleHeight: CGFloat = 18.0
        let minBubbleWidth: CGFloat = 15.0
        let maxBubbleWidth: CGFloat = Self.width * 0.62
        
        //mesRect -> 텍스트 너비가 작으면 가장 작은 너비, 텍스트가 길변 큰 폭을 차지하도록 구현
        let mesRect = model.message.estimatedTextRect(width: maxBubbleWidth)
        let mesWidth = mesRect.width <= minBubbleWidth ?
        minBubbleWidth :
        (mesRect.width >= maxBubbleWidth) ? maxBubbleWidth : mesRect.width
        let mesHeight = mesRect.height <= minBubbleHeight ? minBubbleHeight : mesRect.height
        
        let bubbleHeight = mesHeight + 15
        let bubbleWidth = mesWidth + 20
        let xOffSet = (size.width - bubbleWidth) / 2 - 20.0 // 말풍선 offSet 설정
        HStack {
            if model.userID != "나" { //상대 프로필
                userProfileView()
                    .offset(x: -xOffSet + 55)
            } else { // 나 날짜 부분
                dateChattView()
                    .offset(x: xOffSet - 27, y: 4)
            }
            //말풍선 부분
            Rectangle()
                .fill(.clear)
            //isRight ? Color.red : Color.blue) //말풍선 색 변경해주기
                .frame(width: bubbleWidth, height: bubbleHeight)
                .background(
                    //말풍선 이미지로 이쁘게 해서 구현해도 될듯~
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isRight ? Color.primaryOrange.opacity(0.8) : Color.primaryGray.opacity(0.6))
                        .frame(width: bubbleWidth - 5, height: bubbleHeight)
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(x: isRight ? 1.0 : -1.0) // 이미지 뒤집기~
                        .offset(x: isRight ? xOffSet - 35 : -xOffSet + 55)
                    
                )
                .overlay(alignment: isRight ? .trailing : .leading) {
                    HStack {
                        Text(model.message)
                            .font(.pretendardRegular16)
                            .frame(width: mesWidth, height: mesHeight)
                            .padding(isRight ? .trailing : .leading, 15)
                            .offset(x: isRight ? xOffSet - 30 : -xOffSet + 50)
                    }
                    //.foregroundStyle(isRight ? ) // 채팅 색 변경
                }
            
            
            if model.userID != "나" { //상대방 날짜 부분
                dateChattView()
                    .offset(x: -xOffSet + 45, y: 4)
            }
        } //:HSTACK
        .id(model.id) //각 cell 아이디 부여
    }
}
// MARK: - 사용자 프로필 부분
private extension ChattingRoomView {
    @ViewBuilder
    func userProfileView() -> some View {
        CommonProfile(image: .asTestProfile, size: 33)
            .vTop()
    }
}
// MARK: - 채팅 날짜 부분
private extension ChattingRoomView {
    @ViewBuilder
    func dateChattView() -> some View {
        Text("오전 88:88")
            .font(.pretendardLight12)
            .frame(width: 60, height: 25)
            .vBottom()
    }
}

#Preview {
    ChattingRoomView()
}

extension View {
    func tabBarHidden(_ hidden: Bool) -> some View {
        self.toolbar(hidden ? .hidden : .visible, for: .tabBar)
    }
}

// MARK: - 채팅 텍스트에 따른 크기 조절
extension String {
    func estimatedTextRect(width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGRect {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let option: NSStringDrawingOptions = [
            .usesLineFragmentOrigin
        ]
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16.0, weight: .regular)
        ]
        return NSString(string: self).boundingRect(
            with: size,
            options: option,
            attributes: attributes,
            context: nil
        )
    }
}