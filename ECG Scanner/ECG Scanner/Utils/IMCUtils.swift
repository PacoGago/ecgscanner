//
//  IMCUtils.swift
//  ECG Scanner
//
//  Created by Paco Gago on 07/07/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI

protocol IMCUtils {
    func getAdultCategoryBMI(bmi_: Double) -> String
    func getAdultColorBMI(bmi_: Double) -> Color
    func weightData() -> [Double]
    func sanitanizeDoubleWeight(weight_: Double) -> String
}

class IMCUtilsImpl: IMCUtils{
    
    func weightData() -> [Double]{
        
        var res = Array<Double>()
        
        for index in 1...657 {
            res.append(Double(index))
            res.append(Double(index)+0.5)
        }

        return res
    }
    
    func sanitanizeDoubleWeight(weight_: Double) -> String{

        return String(format:"%.1f", weight_)
    }

    func getAdultCategoryBMI(bmi_: Double) -> String{
        
        if (bmi_ < 18.50){
            if (bmi_ < 16.0){
                return ConstantsUtils.SevereThinness
            }
            
            if (bmi_ >= 16.0 && bmi_ <= 16.99){
                return ConstantsUtils.ModerateThinness
            }
              
            if (bmi_ >= 17.00 && bmi_ <= 18.49){
                return ConstantsUtils.SlightThinness
            }
        }
        
        if (bmi_ >= 18.5 && bmi_ <= 24.99){
            return ConstantsUtils.NormalWeight
        }
        
        if (bmi_ >= 25.00 && bmi_ <= 29.99){
            return ConstantsUtils.Overweight
        }
        
        if (bmi_ >= 30.00 && bmi_ <= 34.99){
            return ConstantsUtils.MildObesity
        }
        
        if (bmi_ >= 35.00 && bmi_ <= 39.99){
            return ConstantsUtils.AverageObesity
        }
        
        if (bmi_ >= 40.00){
            return ConstantsUtils.MorbidObesity
        }
        
        return ""
    }
    
    func getAdultColorBMI(bmi_: Double) -> Color{
        
        if (bmi_ < 18.50){
            if (bmi_ < 16.0){
                return Color(.red)
            }
            
            if (bmi_ >= 16.0 && bmi_ <= 16.99){
                return Color(.red)
            }
              
            if (bmi_ >= 17.00 && bmi_ <= 18.49){
                return Color(.orange)
            }
        }
        
        if (bmi_ >= 18.5 && bmi_ <= 24.99){
            return Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
        }
        
        if (bmi_ >= 25.00 && bmi_ <= 29.99){
            return Color(.orange)
        }
        
        if (bmi_ >= 30.00 && bmi_ <= 34.99){
            return Color(.red)
        }
        
        if (bmi_ >= 35.00 && bmi_ <= 39.99){
            return Color(.red)
        }
        
        if (bmi_ >= 40.00){
            return Color(.red)
        }
        
        return Color(.black)
    }
}
