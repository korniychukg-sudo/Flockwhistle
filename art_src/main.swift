import Foundation

let outDir = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "./out"
let iconDir = CommandLine.arguments.count > 2 ? CommandLine.arguments[2] : outDir
try? FileManager.default.createDirectory(atPath: outDir, withIntermediateDirectories: true)
try? FileManager.default.createDirectory(atPath: iconDir, withIntermediateDirectories: true)

makeGrounds(dir: outDir)
for k in kitBook { makeKitPlate(k, dir: outDir) }
for c in craftBook { makeCraftPlate(c, dir: outDir) }
for f in fieldBook { makeFieldPlate(f, dir: outDir) }
makeIcon(dir: iconDir)
print("plates written to \(outDir)")
