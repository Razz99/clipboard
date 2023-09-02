import Cocoa

class ClipboardMonitor {
    let pasteboard = NSPasteboard.general

    var changeCount = NSPasteboard.general.changeCount

    var recentInputs = [String](repeating: "", count: 5)

    var currentIndex = 0

    var outputPath: String

    init() {        
        outputPath = "/Users/\(NSUserName())/Desktop/copyHistory.txt"
        
        createFileIfNotExists()

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            checkClipboardChange()
        }
    }

    func checkClipboardChange() {
        let newChangeCount = pasteboard.changeCount

        if newChangeCount != changeCount {

            changeCount = newChangeCount

            if let content = getClipboardContent() {
                if !recentInputs.contains(content) {

                    recentInputs[currentIndex] = content

                    currentIndex = (currentIndex + 1) % 5

                    print("\u{001B}[31;1m--------------------Clipboard you copied--------------------\u{001B}[0m")

                    print("\u{001B}[32m\(content)\u{001B}[0m")

                    writeToFile(content:content)
                    
                }
            }
        }
    }

    func createFileIfNotExists() {
        if !FileManager.default.fileExists(atPath: outputPath) {
            FileManager.default.createFile(atPath: outputPath, contents: nil, attributes: nil)
        }
    }

    func getClipboardContent() -> String? {
        return pasteboard.string(forType: .string)!.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func writeToFile(content: String) {
        do {
            let fileHandle = try FileHandle(forWritingTo: URL(fileURLWithPath: outputPath))

            fileHandle.seekToEndOfFile()

            let bullet = " • "

            let line = "\n\n\(bullet)\(content)"

            if let data = line.data(using: .utf8) {
                fileHandle.write(data)

                fileHandle.closeFile()
            }
        } catch {
            print("Error writing to file:", error)
        }
    }

}

let _ = ClipboardMonitor()

RunLoop.current.run()
