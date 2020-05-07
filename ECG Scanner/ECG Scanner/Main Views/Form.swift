//
//  Form.swift
//  ECG Scanner
//
//  Created by Paco Gago on 05/05/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct Form: View {
    var body: some View {
    
        NavigationView {
            
                Section {
                    Text("Hello World")
                }
            
            .navigationBarTitle(Text("SwiftUI"))
        }
    }
}

struct Form_Previews: PreviewProvider {
    static var previews: some View {
        Form()
    }
}
