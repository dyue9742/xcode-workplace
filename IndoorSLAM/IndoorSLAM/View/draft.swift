//
//  draft.swift
//  IndoorSLAM
//
//  Created by Yue Dai on 2021-02-01.
//

import SwiftUI

struct draft: View {
    var body: some View {
        Rectangle.init()
            .frame(width: 10, height: 10)
            .offset(x: 0, y: 0)
            .cornerRadius(3.0)
    }
}

struct draft_Previews: PreviewProvider {
    static var previews: some View {
        draft()
    }
}
