//
//  DayLog+.swift
//  RunLog
//
//  Created by 도민준 on 3/21/25.
//

import Foundation

extension DayLog {
    /// DayLog의 각 section을 RecordDetail 배열로 변환
    func toRecordDetails() -> [RecordDetail] {
        return self.sections.map { RecordDetail(from: $0) }
    }
}
