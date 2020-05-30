//
//  ScheduleRelationship.swift
//  Services
//
//  Created by Zev Eisenberg on 5/30/20.
//

public enum ScheduleRelationship: String, Codable {
    case added = "ADDED"
    case cancelled = "CANCELLED"
    case noData = "NO_DATA"
    case skipped = "SKIPPED"
    case unscheduled = "UNSCHEDULED"
}
