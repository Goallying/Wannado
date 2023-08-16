//
//  HomeView.swift
//  Wannado
//
//  Created by admin on 2023/8/10.
//

import SwiftUI

struct HomeView: View {
    
    
    @StateObject var homeVM :HomeViewModel  = HomeViewModel()
    @State var searchString:String = ""
    @State var abilities:[String] = []
    
    var body: some View {
        
        
        NavigationStack{
         
            List{
                
                if homeVM.isLoading {
                    ProgressView()
                }
                else {
                    ForEach(homeVM.dataSource) { ability in
                        NavigationLink(destination: ability.view) {
                            Text(ability.name)
                        }
                    }

                }
                
            }
            .navigationTitle(Text("Wannado"))
            
        }.searchable(text: $searchString ,
                     placement: SearchFieldPlacement.navigationBarDrawer(displayMode: .always),
                     prompt: Text("搜索内容"))
        .onChange(of: searchString) { newValue in
            
        }
        
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
