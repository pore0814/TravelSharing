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

protocol InvitedFriendsManagerDelegate:class {
    func manager (_ manager: InvitedFriendsManager , didGet invitedList:[WaitingList])
    func manager (_ manager :InvitedFriendsManager, getPermission permissionList:[WaitingList])
}



class InvitedFriendsManager{
    
     var delegate: InvitedFriendsManagerDelegate?
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
    func sendRequestToFriend(_ from: UserInfo, sendRtoF to: UserInfo){

            let frinedData = ["id":to.uid,"email":to.email,"photo":to.photoUrl,"username":to.userName,"status": false] as [String : Any]
    
                     FireBaseConnect.databaseRef
                        .child("requestsFromMe")
                        .child(from.uid)
                        .child(to.uid)
                        .setValue(frinedData)
    }

//等待朋友Premissiom
    func waitingPermission(_ from: UserInfo, sendRtoF to: UserInfo){

       let myData =  ["id":from.uid,"email":from.email,"photo":from.photoUrl,"username":from.userName,"status": false] as [String : Any]
        
        
                        FireBaseConnect.databaseRef
                            .child("requestsWaitForPermission")
                            .child(to.uid)
                            .child(from.uid)
                            .updateChildValues(myData)
    }
//已傳送邀請名單
    func requestsFromMeList(){
        guard let userid = UserManager.shared.getFireBaseUID() else { return}
      
       var  waitingListArray: [WaitingList] = []
        
                FireBaseConnect.databaseRef
                                .child("requestsFromMe")
                                .queryOrderedByKey()
                                .queryEqual(toValue: userid)
                    .observe(.value, with: { (snapshot) in
                // waitingListArray.removeAll()
                    waitingListArray.removeAll()
            guard let lists = snapshot.value as? [String: [String: [String: Any]]]  else {return}
                    for list in lists.values {
                        print(list.values)
                        for llll in list.values{
                           guard let email = llll["email"] as? String,
                            let id    = llll["id"] as? String,
                            let username = llll["username"] as? String,
                            let photo    = llll["photo"] as? String,
                            let status   = llll["status"] as? Bool else {return}
                            let watingList = WaitingList(email: email, photoUrl: photo, uid: id, userName: username, status: status)
                            waitingListArray.append(watingList)
                        }
               self.delegate?.manager(self, didGet: waitingListArray)
            }
})
}
//交友邀請
    func requestsWaitForPermission(){
                guard let userid = UserManager.shared.getFireBaseUID() else { return}
        
                var  waitingListArray: [WaitingList] = []
                     waitingListArray.removeAll()
                FireBaseConnect.databaseRef
                    .child("requestsWaitForPermission")
                    .queryOrderedByKey()
                    .queryEqual(toValue: userid)
                    .observe(.value, with: { (snapshot) in
                        guard let lists = snapshot.value as? [String: [String: [String: Any]]]  else {return}
                        for list in lists.values {
                            print(list.values)
                            for llll in list.values{
                                guard let email = llll["email"] as? String,
                                    let id    = llll["id"] as? String,
                                    let username = llll["username"] as? String,
                                    let photo    = llll["photo"] as? String,
                                    let status   = llll["status"] as? Bool else {return}
                                let watingList = WaitingList(email: email, photoUrl: photo, uid: id, userName: username, status: status)
                                waitingListArray.append(watingList)
                            }
                        self.delegate?.manager(self, getPermission: waitingListArray)
                        }
               })
     }
    
//取消邀請
    func cancelRequestFromMe(friendID:String) {
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        /* 先刪除Schedule_id */
        FireBaseConnect.databaseRef
            .child("requestsFromMe")
            .child(userid)
            .child(friendID)
            .removeValue()
        }
//刪除 Permission名單裡我的邀請
    func cancelPermission(friendID:String) {
        guard let userid = UserManager.shared.getFireBaseUID() else {return}
        /* 先刪除Schedule_id */
        FireBaseConnect.databaseRef
            .child("requestsWaitForPermission")
            .child(friendID)
            .child(userid)
            .removeValue()
    }
    
    func  friends(friendID:String){
//      let myFriendList = ["id":to.uid,"email":to.email,"photo":to.photoUrl,"username":to.userName,"status": false] as [String : Any]
//        
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
                
            }
  */
//            let wiatingList = lists.values as? [[String:Any]]
//           print(wiatingList)
            
//            for  list in lists.values {
//                
//                //let email = 
//            }


    
    
   
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
//    
    





