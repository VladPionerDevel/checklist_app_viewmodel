//
//  MenuListToolBar.swift
//  CheckList
//
//  Created by pioner on 15.06.2021.
//

import SwiftUI

struct MenuListToolBar: View {
    
    @ObservedObject var viewModel: ViewModel
    @Binding var isShow: Bool
    @Binding var isNavigationToListsView: Bool
    @Binding var isPresentedSettings: Bool
    
    var body: some View {
        HStack{
            Spacer()
            Button {
                self.isNavigationToListsView = true
                isShowToggle(value: false)
            } label: {
                Text("Edit Lists")
                Image(systemName: "pencil")
            }
            .padding(.trailing, 10)
            .padding(.top, 10)
            
            Button {
                self.isPresentedSettings = true
            } label: {
                Text("New Lists")
                Image(systemName: "plus")
            }
            .padding(.trailing, 10)
            .padding(.top, 10)
            
            Spacer()
            
            Button {
                withAnimation {
                    isShowToggle()
                }
            } label: {
                Image(systemName: "xmark")
            }
            .padding(.top, 10)
            .padding(.trailing,10)
        }
        .padding(.bottom, 10)
        .background(UIColor.getColorDefaultColorBackground(withData: viewModel.listActive?.color))
    }
    
    func isShowToggle(value: Bool? = nil){
        if let value = value {
            self.isShow = value
        } else {
            isShow.toggle()
        }
    }
}
