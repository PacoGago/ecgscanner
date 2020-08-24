//
//  ImageText.swift
//  ECG Scanner
//
//  Created by Paco Gago on 03/08/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

struct ImageTextView: View {
    
    var img: Image
    var txt: Text
    
    var body: some View {
        HStack{
            img
            txt
        }
    }
}

struct ImageTextView_Previews: PreviewProvider {
    static var previews: some View {
        ImageTextView(img: Image(systemName: "bookmark"), txt: Text("Test"))
    }
}

