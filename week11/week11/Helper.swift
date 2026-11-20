import Foundation

// four kinds of city sounds
let categories = ["Traffic", "Transit", "Buildings", "Machines"]

// symbol for each category
func categoryIcon(_ category: String) -> String {
    switch category {
    case "Traffic":
        return "car.fill"
    case "Transit":
        return "tram.fill"
    case "Buildings":
        return "building.2.fill"
    default:                       // Machines
        return "gearshape.2.fill"
    }
}

// checking file creation time for sorting
func getFileDate(for file: URL) -> Date {
    let attributes = try! FileManager.default.attributesOfItem(atPath: file.path)
    return attributes[.creationDate] as! Date
}

// category from the file name: "Transit_Q train" → "Transit"
func sampleCategory(_ url: URL) -> String {
    let fileName = url.deletingPathExtension().lastPathComponent
    return String(fileName.split(separator: "_", maxSplits: 1)[0])
}

// name after the category: "Transit_Q train" → "Q train"
func displayName(_ url: URL) -> String {
    let fileName = url.deletingPathExtension().lastPathComponent
    return String(fileName.split(separator: "_", maxSplits: 1)[1])
}

// file name created using time
func timeName() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH-mm-ss"
    return formatter.string(from: Date())
}

// formatting seconds into clock text, e.g. 75 → "1:15"
func timeText(_ seconds: Int) -> String {
    return Duration.seconds(seconds).formatted(.time(pattern: .minuteSecond))
}
