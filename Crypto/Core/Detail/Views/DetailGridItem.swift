import SwiftUI

struct DetailGridItem: View {
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            
            HStack(spacing: 4) {
                Text(value)
                    .font(.headline)
                    .foregroundStyle(Color.theme.accent)
                
                if let percentageChange = percentageChange {
                    Image(systemName: percentageChange >= 0 ? "triangle.fill" : "arrowtriangle.down.fill")
                        .font(.caption)
                        .foregroundStyle(percentageChange >= 0 ? Color.theme.green : Color.theme.red)
                        .rotationEffect(
                            Angle(degrees: percentageChange >= 0 ? 0 : 180)
                        )
                    
                    Text(percentageChange.asPercentString())
                        .font(.caption)
                        .bold()
                        .foregroundStyle(percentageChange >= 0 ? Color.theme.green : Color.theme.red)
                }
            }
        }
    }
}
