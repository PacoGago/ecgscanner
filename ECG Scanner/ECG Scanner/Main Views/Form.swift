//
//  Form.swift
//  ECG Scanner
//
//  Created by Paco Gago on 05/05/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct Form: View {
    
    @State private var showConfig = false
    
    var body: some View {
    
        ZStack(alignment: .topLeading) {
        
            //Settings
            Button(action: {
                self.showConfig.toggle()
                print("I touch it")
            }, label: {
                Image(systemName: "gear")
                .font(.system(size: 22.0))
                .frame(width: 50, height: 50)
                .foregroundColor(.black)
            })
            .sheet(isPresented: self.$showConfig){
                Form()
            }
            
            
        }.frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct Form_Previews: PreviewProvider {
    static var previews: some View {
        Form()
    }
}
