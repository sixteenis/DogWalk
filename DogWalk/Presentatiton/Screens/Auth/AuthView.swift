//
//  AuthView.swift
//  DogWalk
//
//  Created by 소정섭 on 10/31/24.
//

import SwiftUI

struct AuthView: View {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var body: some View {
            VStack {                
                VStack(spacing: 15) {
                    Text("반가워요!")
                        .font(.bagelfat28)
                        .foregroundColor(Color.primaryBlack)
                    
                    Text("도그워크와 함께\n즐거운 산책을 시작해볼까요?")
                        .font(.pretendardBlack20)
                        .foregroundColor(Color.primaryBlack)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)
                Spacer()

                Image(.test) // 강아지 이미지 에셋 필요
                    .resizable()
                    .frame(width: width/4, height: width/4)
                    .padding(.bottom)
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image("kakao_login_medium_wide")
                            .resizable()
                            .scaledToFit()
                    })
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image("appleid_button (4)")
                            .resizable()
                            .scaledToFit()
                    })
                }
                .padding(.horizontal, 20)
            }
            .background(Color.primaryLime)
        }
}

#Preview {
    AuthView()
}
