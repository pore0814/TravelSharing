//
//  InvitatedFriendManager.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/31.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase


class InvitedFriendsManager{
    
//    func addFriend(){
//        var ref = Database.database().reference()
//        ref.child("addFriends")
//            .queryOrderedByKey()
//            .queryEqual(toValue: "35zBW8dyyeSdBbE69IzWHg4ALlh2")
//            .observeSingleEvent(of: .value, with: { (snapshot) in
//                print(snapshot)
//                if snapshot.childrenCount != 0 {
//
//                    print("f")
//
//                } else {
//                    //                    self.createUser()
//                }
//            })
//    }
   
    func addFriend(_ from: UserInfo, sendRtoF to: UserInfo){
        
        let autoKey = FireBaseConnect.databaseRef.childByAutoId().key
        
        let fromUser = ["id": from.uid, "email": from.email, "photo": from.photoUrl]
        let toUser = ["id": to.uid, "email": to.email , "photo": to.photoUrl]
        
        let childUpdates = ["/from":fromUser,
                            "/to":toUser]
        
        FireBaseConnect.databaseRef.child("requests").child(autoKey).updateChildValues(childUpdates)
    }
    
    
}


