//
//  ECGChart.swift
//  ECG Scanner
//
//  Created by Paco Gago on 14/10/2020.
//  Copyright © 2020 Francisco Gago. All rights reserved.
//

import SwiftUI
import Combine

struct ECGChartView: View {
    
    @ObservedObject var stocks = Stocks()
    
    var body: some View {
        
        VStack{
            
            //Subtitle
            Text("Digitalización:")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .offset(x: 0, y: 5)
            
            LineView(data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.04830000000000112, 0.0, 0.04830000000000112, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.04830000000000112, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -0.04830000000000112, -0.04830000000000112, -0.09659999999999869, -0.19320000000000093, -0.2414999999999985, -0.2897999999999996, -0.3863999999999983, -0.4346999999999994, -0.5795999999999992, -0.6761999999999979, -0.7728000000000002, -0.8693999999999988, -0.9177, -0.9660000000000011, -1.0142999999999986, -1.1109000000000009, -1.1591999999999985, -1.2074999999999996, -1.2074999999999996, -1.2558000000000007, -1.2558000000000007, -1.2558000000000007, -1.2558000000000007, -1.2558000000000007, -1.2558000000000007, -1.2558000000000007, -1.2074999999999996, -1.2074999999999996, -1.1591999999999985, -1.1109000000000009, -1.0625999999999998, -0.9660000000000011, -0.9177, -0.8211000000000013, -0.724499999999999, -0.6279000000000003, -0.5312999999999981, -0.4346999999999994, -0.33810000000000073, -0.2897999999999996, -0.2414999999999985, -0.19320000000000093, -0.1448999999999998, -0.1448999999999998, -0.1448999999999998, -0.1448999999999998, -0.1448999999999998, -0.09659999999999869, -0.04830000000000112, -0.04830000000000112, -0.04830000000000112, -0.04830000000000112, -0.04830000000000112, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.04830000000000112, 0.04830000000000112, 0.0, 0.0, 0.0, 0.0, 0.04830000000000112, 0.0, 0.0, 0.0, 0.04830000000000112, 0.0, 0.0, 0.04830000000000112, 0.0, 0.04830000000000112, 0.0, 0.04830000000000112, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.04830000000000112, 0.0, 0.04830000000000112, 0.0, 0.04830000000000112, 0.0, 0.04830000000000112, 0.09660000000000224, 0.09660000000000224, 0.1448999999999998, 0.19320000000000093, 0.24150000000000205, 0.2897999999999996, 0.38640000000000185, 0.2897999999999996, 0.19320000000000093, -0.4346999999999994, -0.6761999999999979, -1.5456000000000003, -2.5115999999999996, -3.6225000000000005, -3.8156999999999996, -4.878299999999999, -5.8926, -6.5205, -6.6654, -6.8103, -6.617100000000001, -7.6797, -7.728, -6.6654, -6.713699999999999, -6.5205, -5.6028, -5.168099999999999, -3.863999999999999, -2.559899999999999, -1.6905000000000001, -1.1109000000000009, -0.6761999999999979, 0.04830000000000112, 0.33810000000000073, 0.4346999999999994, 0.48300000000000054, 0.5313000000000017, 0.5313000000000017, 0.5313000000000017, 0.48300000000000054, 0.5313000000000017, 0.48300000000000054, 0.48300000000000054, 0.48300000000000054, 0.48300000000000054, 0.48300000000000054, 0.4346999999999994, 0.38640000000000185, 0.38640000000000185, 0.38640000000000185, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.2897999999999996, 0.2897999999999996, 0.33810000000000073, 0.2897999999999996, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.2897999999999996, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.33810000000000073, 0.2897999999999996, 0.2897999999999996, 0.2897999999999996, 0.24150000000000205, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.1448999999999998, 0.09660000000000224, 0.04830000000000112, -0.09659999999999869, -0.19320000000000093, -0.2414999999999985, -0.2897999999999996, -0.48300000000000054, -0.5795999999999992, -0.6279000000000003, -0.6761999999999979, -0.8211000000000013, -0.8693999999999988, -0.8211000000000013, -1.0142999999999986, -0.8693999999999988, -0.8211000000000013, -1.2074999999999996, -1.3040999999999983, -1.3523999999999994, -1.4007000000000005, -1.4972999999999992, -1.5456000000000003, -1.642199999999999, -1.6905000000000001, -1.7388000000000012, -1.8354, -1.9319999999999986, -1.9802999999999997, -2.0768999999999984, -2.1251999999999995, -2.1735000000000007, -2.2700999999999993, -2.3184000000000005, -2.3184000000000005, -2.3667, -2.414999999999999, -2.4633000000000003, -2.4633000000000003, -2.5115999999999996, -2.5115999999999996, -2.5115999999999996, -2.5115999999999996, -2.559899999999999, -2.5115999999999996, -2.5115999999999996, -2.5115999999999996, -2.5115999999999996, -2.5115999999999996, -2.5115999999999996, -2.5115999999999996, -2.559899999999999, -2.5115999999999996, -2.5115999999999996, -2.5115999999999996, -2.5115999999999996, -2.4633000000000003, -2.4633000000000003, -2.3667, -2.3184000000000005, -2.2700999999999993, -2.1735000000000007, -2.028600000000001, -1.9802999999999997, -1.883700000000001, -1.7870999999999988, -1.6905000000000001, -1.5938999999999979, -1.4972999999999992, -1.4007000000000005, -1.3523999999999994, -1.2558000000000007, -1.0625999999999998, -1.0142999999999986, -0.9177, -0.724499999999999, -0.6761999999999979, -0.5795999999999992, -0.48300000000000054, -0.3863999999999983, -0.2897999999999996, -0.2414999999999985, -0.1448999999999998, -0.09659999999999869, -0.04830000000000112, 0.0, 0.0, 0.04830000000000112, 0.04830000000000112, 0.09660000000000224, 0.09660000000000224, 0.09660000000000224, 0.1448999999999998, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093, 0.19320000000000093], title: "", subtitle: "")
            .padding()
        }
        

    }
}

class Stocks : ObservableObject{
    
    @Published var prices = [Double]()
    @Published var currentPrice = "...."
    
    var cancellable : Set<AnyCancellable> = Set()
    var urlBase = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=NSE&apikey=BMOD3LW57RJLI5LR&datatype=json"
    
    init() {
        fetchStockPrice()
    }
    
    func fetchStockPrice(){
        
        URLSession.shared.dataTaskPublisher(for: URL(string: "\(urlBase)")!)
            .map{output in
                
                return output.data
        }
        .decode(type: StocksDaily.self, decoder: JSONDecoder())
        .sink(receiveCompletion: {_ in
            print("completed")
        }, receiveValue: { value in
            
            
            var stockPrices = [Double]()
            
            let orderedDates =  value.timeSeriesDaily?.sorted{
                guard let d1 = $0.key.stringDate, let d2 = $1.key.stringDate else { return false }
                return d1 < d2
            }
            
            guard let stockData = orderedDates else {return}
            
            for (_, stock) in stockData{
                if let stock = Double(stock.close){
                    if stock > 0.0{
                        stockPrices.append(stock)
                    }
                }
            }
            
            DispatchQueue.main.async{
                self.prices = stockPrices
                self.currentPrice = stockData.last?.value.close ?? "..."
            }
        })
            .store(in: &cancellable)
        
    }
}


struct StockPrice : Codable{
    
    let open: String
    let close: String
    let high: String
    let low: String
    
    private enum CodingKeys: String, CodingKey {
        
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
    }
}

struct StocksDaily : Codable {
    let timeSeriesDaily: [String: StockPrice]?
    
    private enum CodingKeys: String, CodingKey {
        case timeSeriesDaily = "Time Series (Daily)"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        timeSeriesDaily = try (values.decodeIfPresent([String : StockPrice].self, forKey: .timeSeriesDaily))
    }
}

extension String {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    var stringDate: Date? {
        return String.shortDate.date(from: self)
    }
}

struct ECGChartView_Previews: PreviewProvider {
    static var previews: some View {
        ECGChartView()
        
    }
}
