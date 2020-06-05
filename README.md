# Android-Screenshot-Scripts
A collection of scripts to make it easier to screenshot android devices.

## TL;DR
Use `adb-screenshot` to make a screenshot in your current file system location. If you want to clean up your statusbar beforehand, for example to get nice screenshots for the Google Play Store, use `adb-statusbar -c` beforehand and end this mode with `adb-statusbar -e` when you're done.

## Installation
Download the scripts and put them in the folder where you keep your user scripts (for me that is `~/.bin/`, but you can put it almost anywhere as long as it is in your PATH).
If you have never used adb in the command line before, you might need to install the Android Platform Tools before you can start:

macOS: `brew cask install android-platform-tools`  
Debian/Ubuntu: `sudo apt-get install adb`  
Fedora/SUSE: `sudo yum install android-tools`  
Depending on your Linux distro, these might also be included in your Android Studio installation or installable via it's SDK manager.

🏗 I plan to provide a brew tap formula in the future to make installation easier, see the roadmap section.

## Usage
### `adb-screenshot`
This script is generally stable. It has a few command line arguments which can be accessed by using the argument `-h`:
| Argument | Explanation |
| :------: | :---------- |
|   `-h`   | Shows the help page. |
|   `-d`   | Specify the adb device name. You can get the relevant device name via `adb devices -l`. |
|   `-f`   |   The filename where the file should be saved. Per default it saves the screenshot in the current directory with the filename following the macOS Screenshot filename convention (Example: `Screenshot 2020-01-01 at 12.00.00`). |

### `adb-statusbar`
⚠️ This script is much more unstable due to it using the Android demo mode. This means that how good this script works is dependent on the Android version and the devices manufacturer. As of now, I can only guarantee that this script works on Pixel phones and on Android One devices.

⛔️ Known bug: On Xiaomi devices, this script might crash the system launcher.

**Important:** This script engages the Android demo mode, which needs to be disengaged after you're done to return the statusbar to it's normal state. While this might happen anyway eventually (for example on configuration change), I strongly recommend doing this manually with `adb-statusbar -e`

It also has a few command line arguments:
| Argument | Explanation |
| :------: | :---------- |
|   `-h`   | Shows the help page. |
|   `-d`   | Specify the adb device name. You can get the relevant device name via `adb devices -l`. |
|   `-c`   | Start up demo mode and clean up the statusbar. |
|   `-h`   | Exit the demo mode and return everything to normal. |

## Roadmap
Since I use these scripts during day to day work, annoyances or bugs that happen during my use will be fixed relatively quickly. I have a few major goals that take up a bit more time and that I will start when I get to it.

| Status | Skript           |     Goal      |
| :----: | :--------------: |:------------- |
|   ✅   |  `adb-screenshot` | Detect and show an error if the current app does not allow screenshots.
|   🏗   |        both       | Make this repository usable via Homebrew tap. While I don't believe that these scripts are relevant enough to warrant inclusion in the normal Homebrew formulas, this might make installation easier for macOS users like myself. |
|   ❌   |  `adb-statusbar`  | Make the statusbar script more stable and handle errors better. |

