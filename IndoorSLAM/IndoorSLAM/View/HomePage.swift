//
//  HomePage.swift
//  IndoorSLAM
//
//  Created by Yue Dai on 2021-01-23.
//

import SwiftUI

struct HomePage: View {
    
    @StateObject var detection = ObjectDetection()
    @StateObject var contours = ContourDetection()
    
    var body: some View {
        VStack (alignment: .center) {
            TabView (content: {
                CameraInsight(detection: detection, contours: contours)
                    .frame(width: UIScreen.main.bounds.width,
                           alignment: .center)
                    .tabItem({
                        Image(systemName: "camera.fill")
                            .font(.subheadline)
                        Text("Scanning")
                    })
                Storage()
                    .frame(width: UIScreen.main.bounds.width,
                           alignment: .center)
                    .tabItem({
                        Image(systemName: "photo.fill")
                            .font(.subheadline)
                        Text("Pictures")
                    })
            })
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}
