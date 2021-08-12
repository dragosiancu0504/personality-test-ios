//
//  RadioButton.swift
//  PersonalityTest
//
//  Created by Dragos Iancu on 12.08.2021.
//

import SwiftUI

struct RadioButton: View {
    var id: Int
    var value: String
    @Binding var selectedID: Int
    
    var body: some View {
        HStack {
            Button(action: {
                self.selectedID = self.id
            }){
                HStack {
                    ZStack {
                        Circle()
                            .stroke(self.id == self.selectedID ? Color.blue : Color(UIColor.darkGray))
                            .frame(width: 18, height: 18)
                            .padding()
                        
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(self.id == self.selectedID ? Color.blue: Color.clear)
                    }
                    
                    Text(value)
                        .font(.custom("Montserrat", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(Color(UIColor.darkGray))
                }
            }
            Spacer()
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}
