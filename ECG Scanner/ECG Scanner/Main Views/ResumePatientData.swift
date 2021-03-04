import SwiftUI

struct ResumePatientDataView: View {
    
    @EnvironmentObject var p: Patient
    @State var smk: String = ""
    
    var body: some View {
        
        List {
            Section(header: ImageTextView(img: Image(systemName: "info.circle.fill"), txt: Text("Datos generales").bold())) {
                
                Text("Nombre: ").bold() + Text(p.name)
                Text("Apellidos: ").bold() + Text(p.firstSurname + " " + p.secondSurname)
                Text("Dirección: ").bold() + Text(p.address)
                Text("Ciudad: ").bold() + Text(p.city)
                Text("Provincia: ").bold() + Text(p.province)
            }

            Section(header: ImageTextView(img: Image(systemName: "person.circle.fill"), txt: Text("Perfil de salud"))) {
                Text("Género: ").bold() + Text(p.genre)
                Text("Edad: ").bold() + Text(String(p.age) + " años")
                Text("Peso: ").bold() + Text(String(p.weight) + " kg")
                Text("Altura: ").bold() + Text(String(p.height) + " cm")
                Text("IMC: ").bold() + Text(String(p.bmi.rounded()))
            }

            Section(header: ImageTextView(img: Image(systemName: "heart.circle.fill"), txt: Text("Datos médicos"))) {
                
                Text("Fumador: ").bold() + Text(p.smoker ? "Sí" : "No")
                Text("Alergías: ").bold() + Text(p.allergy)
                Text("Enf. Crónicas: ").bold() + Text(p.chronic)
                Text("Medicación: ").bold() + Text(p.medication)
                Text("Hospital: ").bold() + Text(p.hospital)
            }
        }.listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
}

struct ResumePatientDataView_Previews: PreviewProvider {
    static var previews: some View {
        ResumePatientDataView()
    }
}
