# 🐶 DogWalk
"사용자의 애견 산책 일상을 기록하고, 
유저들과 산책 일상 또는 애견 관련 정보를 공유하는 소셜 커뮤니티 서비스"


<br>


## 📱 **주요 기능**
| 홈 | 서재 | 챌린지방 | 위젯 |
|---------------|---------------|---------------|---------------|
| <img src="https://github.com/user-attachments/assets/d2cf28e0-a484-4df9-96f3-30873989d362" width="200" /> | <img src="https://github.com/user-attachments/assets/01738047-dbc6-4c59-b481-439b6f47e0df" width="200" /> | <img src="https://github.com/user-attachments/assets/5d91c9d4-2c99-4635-9d98-c52ee1cf2ee9" width="200" /> | <img src="https://github.com/user-attachments/assets/0ba89026-2500-4518-b708-bf26277cf20e" width="200" /> |
> 🔥 산책 기록
    
> 🔍 실시간 1:1 채팅
    
> 👀 산책 인증 게시글 조회

> ✍️ 게시글 작성

    
  
<br>


## 💻 개발 환경
<p align="left">
<img src ="https://img.shields.io/badge/Swift-5.10-ff69b4">
<img src ="https://img.shields.io/badge/Xcode-15.4-blue">
<img src ="https://img.shields.io/badge/iOS-17.0+-orange">
<br>
    
- **기간**: 2024.10.28 ~ 2024.11.25 (**약 4주**)
- **인원**: iOS 4명, Back-End 2명

    
<br> 

## 🔧 아키텍처 및 기술 스택

- `SwiftUI` / `Combine`
- `MVI` + `Coordinator` 
- `Concurrency` +`DTO` + `Router Pattern` + `Socket`
- `CoreData`/`UserDefault`
    
<br>    


## 🧰 프로젝트 주요 기술 사항
###  프로젝트 아키텍처

> MVI + Repository  + Coordinator
    
- 미정

<br>

> Concurrency +DTO + Router Pattern + Socket
- 미정
    
    
---
### 이미지 캐싱
> 미정
- 미정



<br>

## 🚨 트러블 슈팅
### 값 전달 이슈
- 문제점 🤔
    - 미정
- 해결 🫢
    -  미정
    -  container 구현
<br>

- 문제점 🤔
    -  특정 이벤트를 통해 Widget 업데이트 시 즉시 업데이트되지 않는 문제 발생
- 해결 🫢
    -  Widget의 업데이트는 미리 지정된 시간에 맞춰서 업데이트 되므로 즉시 갱신이 안된다는 점을 파악
    -  앱 내에서 Widget 데이터 업데이트 시 WidgetCenter의 reloadTimeline를 통해 특정 시점에 Widget reload를 통해 데이터 갱신 구현
      
### 미정
- 문제 🤔
    -  미정
- 해결 🫢
    -  미정
