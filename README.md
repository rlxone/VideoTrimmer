<p align="center">
  <img src="https://github.com/rlxone/VideoTrimmer/blob/readme/VideoTrimmer.png"/>
</p>


# VideoTrimmer

Small tool for cutting large video to small ones and making thumbnails based on chroma pixel

## Usage:
`VideoTrimmer file.mp4`

## You need:
- [ffmpeg](https://www.ffmpeg.org/)
- [handbrake-cli](https://handbrake.fr/)

## Notes:
- Change chroma pixel to different in Application.swift
```swift
fileprivate struct Constants {
    static let chroma: (UInt8, UInt8, UInt8) = (0, 254, 0)
    static let xPixel = 256
    static let yPixel = 256
}
```
