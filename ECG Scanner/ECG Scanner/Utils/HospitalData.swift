import SwiftUI
import SwiftyJSON

class HospitalNames{
    
    @Published var names:[String] = []
    let arrayUtils = ArrayUtilsImpl()
    
    init(){

        if let hospitalsJSONPath = NSDataAsset(name: ConstantsViews.HospitalJSONName) {
         
            do {
             
                let jsonhospitals = try JSON(data: hospitalsJSONPath.data)

                for hospital in jsonhospitals[ConstantsViews.HospitalArray].arrayValue {

                    if let name = hospital[ConstantsViews.HospitalAttributes][ConstantsViews.HospitalName].string {
                        names.append(name)
                    }
                }
                
                //Elimina los elementos repetidos y los ordena
                names = arrayUtils.uniq(source: names).sorted(by: <)
             
            } catch let error {
                debugPrint("Parse error: \(error.localizedDescription)")
            }
         
        } else {
            debugPrint("No se ha encontrado el fichero JSON con los hospitales.")
        }
    }
    
    init(province: String){

        if let hospitalsJSONPath = NSDataAsset(name: ConstantsViews.HospitalJSONName) {
         
            do {
             
                let jsonhospitals = try JSON(data: hospitalsJSONPath.data)

                for hospital in jsonhospitals[ConstantsViews.HospitalArray].arrayValue {

                    if let name = hospital[ConstantsViews.HospitalAttributes][ConstantsViews.HospitalName].string {
                        
                        if let nameprovince = hospital[ConstantsViews.HospitalAttributes][ConstantsViews.HospitalProvince].string {
                            
                            if nameprovince.elementsEqual(province){
                                names.append(name)
                            }
                        }
                    }
                }
                
                //Elimina los elementos repetidos y los ordena
                names = arrayUtils.uniq(source: names).sorted(by: <)
             
            } catch let error {
                debugPrint("Parse error: \(error.localizedDescription)")
            }
         
        } else {
            debugPrint("No se ha encontrado el fichero JSON con los hospitales.")
        }
    }
}

class HospitalProvinces{
    
    @Published var names:[String] = []
    let arrayUtils = ArrayUtilsImpl()
    
    init(){

        if let hospitalsJSONPath = NSDataAsset(name: ConstantsViews.HospitalJSONName) {
         
            do {

                let jsonhospitals = try JSON(data: hospitalsJSONPath.data)

                for hospital in jsonhospitals[ConstantsViews.HospitalArray].arrayValue {

                    if let name = hospital[ConstantsViews.HospitalAttributes][ConstantsViews.HospitalProvince].string {
                        names.append(name)
                    }
                }
                
                //Elimina los elementos repetidos y los ordena
                names = arrayUtils.uniq(source: names).sorted(by: <)

            } catch let error {
                debugPrint("Parse error: \(error.localizedDescription)")
            }
         
        } else {
            debugPrint("No se ha encontrado el fichero JSON con los hospitales.")
        }
    }
}
