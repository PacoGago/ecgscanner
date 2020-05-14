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
    
        ZStack(alignment: .topLeading) {
            Text("Subtitle de ECG")
        }.frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct Form_Previews: PreviewProvider {
    static var previews: some View {
        Form()
    }
}
