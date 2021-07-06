//
//  MenuList.swift
//  CheckList
//
//  Created by pioner on 09.06.2021.
//

import SwiftUI

struct MenuList: View {
    @ObservedObject var viewModel: ViewModel
    
    @Binding var isShow: Bool
    @Binding var isNavigationToListsView: Bool
    @Binding var isPresentedSettings: Bool
    @State var bounds: GeometryProxy
    
//    var width: CGFloat {
//        return UIScreen.main.bounds.maxX * 0.8
//    }
    
    var body: some View {
        
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -30 {
                    withAnimation {
                        self.isShowToggle(value: false)
                    }
                }
            }
        
        return ZStack (alignment: .leading){
            
            if (isShow) {
                Rectangle()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .background(Color(red: 0,green: 0, blue: 0))
                    .opacity(0.15)
                    .transition(.opacity)
                    .edgesIgnoringSafeArea(.bottom)
            }
            
            VStack  {
                
                MenuListToolBar(viewModel: viewModel, isShow: $isShow, isNavigationToListsView: $isNavigationToListsView, isPresentedSettings: $isPresentedSettings)
                
                ScrollView {
                    ForEach(viewModel.lists){ list in
                        VStack(spacing: 0) {
                            HStack{
                                Image(systemName: "list.dash")
                                    .foregroundColor(Color(UIColor.getColorDefaultColorLabel(withData: list.color)))
                                Text(list.name ?? "")
                                Spacer()
                                Text(viewModel.getCountPerformedTasks(list: list))
                                    .foregroundColor(Color(UIColor.systemGray4))
                                if list.isActive {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal,15)
                            .background(list.isActive ? Color(UIColor.systemGray5) : Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.setListActive(list: list)
                                isShowToggle()
                            }
                            Divider()
                                .padding(.horizontal,10)
                        }
                        
                    }
                    
                    
                }
                .padding(.top, 10)
            }
            .frame(minWidth: 0, maxWidth: bounds.size.width*0.8, minHeight: 0, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
            .offset(x: isShow ? 0 : -(bounds.size.width*0.8), y: 0)
            .animation(.easeInOut(duration: 0.5))
            .edgesIgnoringSafeArea(.bottom)
        }
        .gesture(drag)
    }
    
    func isShowToggle(value: Bool? = nil){
        if let value = value {
            self.isShow = value
        } else {
            isShow.toggle()
        }
    }
}

