//
//  CheckoutView.swift
//  iDine
//
//  Created by Santiago Cento on 25/03/2024.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var order: Order
    @State private var paymentType = "Cash"
    @State private var addLoyaltyDetails = false
    @State private var loyaltyNumber = ""
    @State private var tipAmount = 15
    @State private var showingPaymentAlert = false
    
    var totalPrice: String {
        let total = Double(order.total)
        let tipValue = total / 100 * Double(tipAmount)
        return (total + tipValue).formatted(.currency(code: "ARS"))
    }
    
    let tipAmounts = [10, 15, 20, 25, 0]
    
    let paymentTypes = ["Cash", "Credit Card", "iDine Points"]
    
    var body: some View {
        Form {
            Section {
                Picker("How do you want to pay?", selection: $paymentType) {
                    ForEach(paymentTypes, id: \.self) {
                        Text($0)
                    }
                }
                Toggle("Add iDine loyalty card", isOn: $addLoyaltyDetails.animation())
                if addLoyaltyDetails {
                    TextField("Enter your iDine ID", text: $loyaltyNumber)
                }
            }
            
            Section("Add a tip?") {
                Picker("Percentage:", selection: $tipAmount) {
                    ForEach(tipAmounts, id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Section("Total: \(totalPrice)") {
                Button("Confirm order") {
                    showingPaymentAlert.toggle()
                }
            }
        }
        .alert("Order Confirmed", isPresented: $showingPaymentAlert){
            
        } message: {
            Text("Your total was \(totalPrice) - Thank you!")
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CheckoutView().environmentObject(Order())
}
