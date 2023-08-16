//
//  HomeViewModel.swift
//  Wannado
//
//  Created by admin on 2023/8/14.
//

import Foundation
import SwiftUI

class HomeViewModel:ObservableObject{

    @Published var dataSource:[AbilityLink] = []
    @Published var isLoading:Bool = false
    
    
    init(){
        getHomeListData()
    }    
    func getHomeListData(){
        
        isLoading = true
        
        dataSource.append(AbilityLink(name: "视频去水印",
                                      view: AnyView(VideoMarkView())))
        dataSource.append(AbilityLink(name: "图片去水印",
                                      view: AnyView(ImageMarkView())))
        
        isLoading = false
    }
    
    
}
