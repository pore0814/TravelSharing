//
//  FirBaseConnect.swift
//  TravelSharing
//
//  Created by 王安妮 on 2018/5/2.
//  Copyright © 2018年 Annie. All rights reserved.
//

import Foundation
import Firebase

struct FireBaseConnect {

  static var databaseRef: DatabaseReference {
        return Database.database().reference()
    }

  static var  storeageProfileRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://travelshare-d17da.appspot.com").child(Constants.ProfileImage)
    }

}
