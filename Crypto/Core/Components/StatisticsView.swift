//
//  StatisticsView.swift
//  Crypto
//
//  Created by Aref on 12/7/24.
//

import SwiftUI

struct StatisticsView: View {
    let stat: StatisticsModel
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(.accentColor)
            if let percentageChange = stat.percentageChange {
                HStack(spacing: 4) {
                    Image(systemName: "triangle.fill")
                        .font(.caption2)
                        .rotationEffect(Angle(degrees: percentageChange >= 0 ? 0 : 180))
                        .foregroundColor(percentageChange >= 0 ? Color.theme.green : Color.theme.red)
                    Text(percentageChange.asPercentString())
                        .foregroundColor(percentageChange >= 0 ? Color.theme.green : Color.theme.red)
                        .font(.caption)
                        .bold()
                }
                .foregroundColor(.secondary)
            }
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(stat: dev.sampleStat)
    }
}
