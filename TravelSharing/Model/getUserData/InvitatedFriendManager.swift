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

protocol InvitedFriendsManagerDelegate: class {
    func manager (_ manager: InvitedFriendsManager, didRequests invitedList: [UserInfo])
    func manager (_ manager: InvitedFriendsManager, getPermission permissionList: [UserInfo])
    func managerFriendList  (_ manager: InvitedFriendsManager, getFriendList friendList: [UserInfo])
}

class InvitedFriendsManager {

  weak var delegate: InvitedFriendsManagerDelegate?
       let autoKey = FireBaseConnect.databaseRef.childByAutoId().key

//    func sendRequestToFriend1(_ from: UserInfo, sendRtoF to: UserInfo){
//        var ref = Database.database().reference()
//        ref.child("requests")
//            .queryOrderedByKey()
//            .queryEqual(toValue: to.uid)
//            .observeSingleEvent(of: .value, with: { (snapshot) in
//                print(snapshot)
//
//                let updates = ["id":from.uid,"email":from.email,"photo":from.photoUrl,"username":from.userName,"status": false] as [String : Any]
//                if snapshot.childrenCount != 0 {
//                    FireBaseConnect.databaseRef.child("requests").child(to.uid).child(self.autoKey).updateChildValues(updates)
//
//                } else {
//                    FireBaseConnect.databaseRef.child("requests").child(to.uid).child(self.autoKey).setValue(updates)
//                }
//            })
//    }
//
//我送出交友邀請
    func sendRequestToFriend(_ from: UserInfo, sendRtoF to: UserInfo) {

            let frinedData = ["id": to.uid, "email": to.email, "photo": to.photoUrl, "username": to.userName] as [String: Any]

                     FireBaseConnect.databaseRef
                        .child("requestsFromMe")
                        .child(from.uid)
                        .child(to.uid)
                        .setValue(frinedData)
    }

//等待朋友Premissiom
    func waitingPermission(_ from: UserInfo, sendRtoF to: UserInfo) {

       let myData =  ["id": from.uid, "email": from.email, "photo": from.photoUrl, "username": from.userName] as [String: Any]

                        FireBaseConnect.databaseRef
                            .child("requestsWaitForPermission")
                            .child(to.uid)
                            .child(from.uid)
                            .updateChildValues(myData)
    }
//已傳送邀請名單
    func requestsFromMeList() {
        guard let userid = UserManager.shared.getFireBaseUID() else { return}

              var  waitingListArray: [UserInfo] = []

                FireBaseConnect.databaseRef
                                .child("requestsFromMe")
                                .queryOrderedByKey()
                                .queryEqual(toValue: userid)
                    //.observeSingleEvent(of: .value, with: { (snapshot) in
                   // .observe(.childChanged) { (snapshot) in
                    .observe(.value) { (snapshot) in

                waitingListArray.removeAll()

            guard let lists = snapshot.value as? [String: [String: [String: Any]]]  else {return}
                      for list in lists.values {
                        for llll in list.values {
                              guard let email = llll["email"] as? String,
                                    let id    = llll["id"] as? String,
                                    let username = llll["username"] as? String,
                                    let photo    = llll["photo"] as? String else {return}
                                    let watingList = UserInfo(email: email, photoUrl: photo, uid: id, userName: username)
                            waitingListArray.append(watingList)
                        }
               self.delegate?.manager(self, didRequests: waitingListArray)
            }
}
}
//交友邀請
    func requestsWaitForPermission() {
        guard let userid = UserManager.shared.getFireBaseUID() else { return}
        
        var  waitingListArray: [UserInfo] = []
        print(waitingListArray.count)
      //  waitingListArray.removeAll()
        FireBaseConnect.databaseRef
            .child("requestsWaitForPermission")
            .queryOrderedByKey()
            .queryEqual(toValue: userid)
            .observe(.value, with: { (snapshot) in
            guard let lists = snapshot.value as? [String: [String: [String: Any]]]  else {return}
                for list in lists.values {
                    for llll in list.values {
                        guard let email = llll["email"] as? String,
                            let id    =   llll["id"] as? String,
                            let username = llll["username"] as? String,
                            let photo    = llll["photo"] as? String else {return}
                            let watingList = UserInfo(email: email, photoUrl: photo, uid: id, userName: username)
                            waitingListArray.append(watingList)
                        }
                        self.delegate?.manager(self, getPermission: waitingListArray)
                    }
            })
    }

//取消邀請
    func cancelRequestFromMe(friendID: String) {
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
/* 先刪除Schedule_id */
                FireBaseConnect.databaseRef
                    .child("requestsFromMe")
                    .child(userid)
                    .child(friendID)
                    .removeValue()
        }
//刪除 Permission名單裡我的邀請
    func cancelPermission(friendID: String) {
         guard let userid = UserManager.shared.getFireBaseUID() else {return}
/* 先刪除Schedule_id */
                    FireBaseConnect.databaseRef
                        .child("requestsWaitForPermission")
                        .child(friendID)
                        .child(userid)
                        .removeValue()
    }
//確認好友
    func  beFriend(myInfo: UserInfo, friendInfo: UserInfo) {

            FireBaseConnect
                .databaseRef
                .child("friends")
                .child(myInfo.uid)
                .child(friendInfo.uid)
                .setValue(["email": friendInfo.email])

            FireBaseConnect
                .databaseRef
                .child("friends")
                .child(friendInfo.uid)
                .child(myInfo.uid)
                .setValue(["email": myInfo.email])
    }

//確認好友後要從Request名單中移出
    func deletRequetFromMe(friendID: String) {
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
/* 先刪除Schedule_id */
        FireBaseConnect.databaseRef
            .child("requestsFromMe")
            .child(friendID)
            .child(userid)
            .removeValue()
    }
//確認好友後要從Permission名單中移出
    func deletePermission(friendID: String) {
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
/* 先刪除Schedule_id */
        FireBaseConnect.databaseRef
            .child("requestsWaitForPermission")
            .child(userid)
            .child(friendID)
            .removeValue()
    }

//撈好友名單
    func myFriendList() {
        guard let userid = UserManager.shared.getFireBaseUID() else { return}

        FireBaseConnect.databaseRef
            .child("friends")
            .queryOrderedByKey()
            .queryEqual(toValue: userid)
            .observe(.value, with: { (snapshot) in
                guard let frinedList = snapshot.value as? [String: Any] else {return}
                for aaa in frinedList.values {
                    guard   let bbb = aaa as? [String: Any] else {return}
                    let ccc = bbb.keys
                    self.getMyFriendsList(Id: ccc)
                }
            })
    }
    func getMyFriendsList(Id: Dictionary<String, Any>.Keys) {
         var  friendsListArray: [UserInfo] = []

                for id in Id {
                    FireBaseConnect.databaseRef
                        .child("users")
                        .queryOrderedByKey()
                        .queryEqual(toValue: id)
                        .observeSingleEvent(of: .value, with: { (snapshot) in

                                guard  let friendInfos = snapshot.value as? [String: Any] else {return}

                                for frinedInfo in friendInfos {
                                      guard let json = frinedInfo.value as? [String: String],
                                            let email = json["email"] as? String,
                                            let uid = json["uid"] as? String,
                                            let photo = json["photoUrl"] as? String,
                                            let username = json["username"] as? String else {return}

                                            let friendsInstance = UserInfo(email: email, photoUrl: photo, uid: uid, userName: username)

                                                friendsListArray.append(friendsInstance)
                                 }
                                                self.delegate?.managerFriendList(self, getFriendList: friendsListArray)
                    })
                }
      }
}

            /*
            var waitingListArray: [UserInfo] = []
            for iii in lists.values {
                print("@@@@@@@@@@@@@@@@@@")
                print(iii)
                for jjj in iii {
                    print("__________ @@@ __________")
                    print(jjj.value)
                    let email = jjj.value["email"]
                    let id = jjj.value["id"]
                    let photo = jjj.value["photo"]
                    let username = jjj.value["username"]
                    let info = UserInfo(email: email!, photoUrl: photo!, uid: id!, userName: username!)
                    print("88888888888888")
                    friendList.append(info)
                    print(friendList)
                    
                    DispatchQueue.main.async {
                      self.delegate?.manager(self, didGet: friendList)
                    }

            }
                }
   
//    func addFriend(_ from: UserInfo, sendRtoF to: UserInfo){
//        
//        let autoKey = FireBaseConnect.databaseRef.childByAutoId().key
//        
//        let fromUser = ["id": from.uid, "email": from.email, "photo": from.photoUrl]
//        let toUser = ["id": to.uid, "email": to.email , "photo": to.photoUrl]
//        
//        let childUpdates = ["/from":fromUser,
//                            "/to":toUser]
//        
//        FireBaseConnect.databaseRef.child("requests").child(autoKey).updateChildValues(childUpdates)
//    }
*/
