//
//  ContentView.swift
//  Calculator
//
//  Created by Peyton Shetler on 4/4/22.
//

import SwiftUI

enum CalculatorButtonType {
    case isNumber
    case isOperator
    case isNegative
    case isPercent
    case isDecimal
    case isClear
}

enum CalculatorButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "/"
    case multiply = "x"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"
    
    var type: CalculatorButtonType {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .isOperator
        case .clear:
            return .isClear
        case .negative:
            return .isNegative
        case .percent:
            return .isPercent
        default:
            return .isNumber
        }
    }
    
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1))
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, none
}

struct ContentView: View {
    
    @State var value = "0"
    @State var runningNumber = "0"
    @State var currentOperation: Operation = .none
    
    let buttons: [[CalculatorButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                // Text Display
                HStack {
                    Spacer()
                    Text(value)
                        .bold()
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                }
                .padding()
                
                // Buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button {
                                self.didTap(item)
                            } label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(
                                        width: self.buttonWidth(item),
                                        height: self.buttonHeight()
                                    )
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item) / 2)
                            }
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }
    
    func didTap(_ button: CalculatorButton) {
        switch button.type {
        case .isOperator:
            setOperation(button)
        case .isClear:
            value = "0"
            runningNumber = "0"
            currentOperation = .none
        case .isDecimal:
            value = "\(value)."
            break
        case .isNegative:
            if value == "0" {
                value = "0"
                break
            }
            value = "-\(value)"
            
            break
        case .isPercent:
            let number = Double(value) ?? 0
            value = "\(number / 100)"
            break
        case .isNumber:
            let number = button.rawValue

            if value.endsWithDecimal() {
                if number == "0" {
                    return
                } else {
                    value = "\(value == "." ? "0." : value )\(number)"
                }
            } else {
                if value == "0" {
                    value = number
                } else {
                    if currentOperation != .none {
                        runningNumber = value
                        value = "\(number)"
                    } else {
                        value = "\(value)\(number)"
                    }
                }
            }
        }
        
        //print("value: ", value, "runningNum: ", runningNumber)
    }
    
    func setOperation(_ button: CalculatorButton) {
        if button == .add {
            currentOperation = .add
            runningNumber = value
        }
        else if button == .subtract {
            currentOperation = .subtract
            runningNumber = value
        }
        else if button == .multiply {
            currentOperation = .multiply
            runningNumber = value
        }
        else if button == .divide {
            currentOperation = .divide
            runningNumber = value
        }
        else if button == .equal {
            let runningValue = runningNumber
            let currentValue = value
            
            if runningValue.isDouble() || currentValue.isDouble() {
                let runningValueAsDouble = runningValue.asDouble()
                let currentValueAsDouble = currentValue.asDouble()
                
                switch currentOperation {
                case .add:
                    value = "\(runningValueAsDouble + currentValueAsDouble)"
                case .subtract:
                    value = "\(runningValueAsDouble - currentValueAsDouble)"
                case .multiply:
                    value = "\(runningValueAsDouble * currentValueAsDouble)"
                case .divide:
                    value = "\(runningValueAsDouble / currentValueAsDouble)"
                case .none:
                    break
                }
            } else {
                let runningValueAsInt = runningValue.asInt()
                let currentValueAsInt = currentValue.asInt()
                
                switch currentOperation {
                case .add:
                    value = "\(runningValueAsInt + currentValueAsInt)"
                case .subtract:
                    value = "\(runningValueAsInt - currentValueAsInt)"
                case .multiply:
                    value = "\(runningValueAsInt * currentValueAsInt)"
                case .divide:
                    value = "\(runningValueAsInt / currentValueAsInt)"
                case .none:
                    break
                }
            }
            
            currentOperation = .none
        }
    }
    
    func buttonWidth(_ item: CalculatorButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4 * 12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
}

extension String {
    func endsWithDecimal() -> Bool {
        return self.last! == "."
    }
    
    func isDouble() -> Bool {
        return self.contains(".")
    }
    
    func asInt() -> Int {
        return Int(self) ?? 0
    }
    
    func asDouble() -> Double {
        return Double(self) ?? 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
