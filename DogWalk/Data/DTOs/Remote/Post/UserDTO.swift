//
//  UserDTO.swift
//  DogWalk
//
//  Created by junehee on 11/3/24.
//

import Foundation

// 게시글 & 댓글 & 채팅방 참여자 응답 (Response)
struct UserDTO: Decodable {
    let user_id: String
    let nick: String
    let profileImage: String
}

extension UserDTO {
    func toDomain() -> UserModel {
        return UserModel(userID: self.user_id,
                         nick: self.nick,
                         profileImage: self.profileImage)
    }
}

// 게시글, 팔로우, 댓글, 채팅방 참여자 사용 모델
struct UserModel {
    let userID: String
    let nick: String
    let profileImage: String
}