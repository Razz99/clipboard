import Cocoa

class ClipboardMonitor {
    let pasteboard = NSPasteboard.general
    var changeCount = NSPasteboard.general.changeCount
    let outputPath = "clipboard_history.txt"
    var previous1 = ""
    var previous2 = ""

    init() {
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
                if previous1.trimmingCharacters(in: .whitespacesAndNewlines) == content.trimmingCharacters(in: .whitespacesAndNewlines) || previous2.trimmingCharacters(in: .whitespacesAndNewlines) == content.trimmingCharacters(in: .whitespacesAndNewlines) || content.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return
                }
                print("\u{001B}[31;1m--------------------Clipboard you copied--------------------\u{001B}[0m")
                print("\u{001B}[32m\(content)\u{001B}[0m")
                print("------------------------------------------------------------")

                writeToFile(content:content)

                previous2 = previous1
                previous1 = content

            }
        }
    }

    func createFileIfNotExists() {
        if !FileManager.default.fileExists(atPath: outputPath) {
            FileManager.default.createFile(atPath: outputPath, contents: nil, attributes: nil)
        }
    }

    func getClipboardContent() -> String? {
        return pasteboard.string(forType: .string)
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
