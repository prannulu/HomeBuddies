//
//  MyActionButtonStyle.swift
//  HomeBuddies
//
//  Created by Pavi Rannulu on 2/8/23.
//

import Foundation
import SwiftUI

struct MyActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            //.foregroundColor(.black)
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .background(Color.themeTertiary)
            .cornerRadius(10)
    }
}

