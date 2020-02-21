# Change Log
All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to Year Notation Versioning.


## Types of Changes

- `Added` for new features.
- `Changed` for changes in existing functionality.
- `Removed` for now removed features.
- `Fixed` for any bug fixes.


## [Unreleased aka "ToDo"](https://github.com/captam3rica/bootstrap/blob/master/CHANGELOG.md#unreleased-aka-todo-1)


## [2020-02-09]

### Fixed

- Made sure that paths were fully qualified. (thanks dhefley)
- WSO Agent needed https infront of the URL so that it would launch.
- Added fushia box icon :)

## [2020-02-09]

### Added

- Updates to README.md
- Figured out the exact URL needed to pull packages directly from GitHub. :)
- General cleanup of the README.md files.
- Tidied up the repo structure and removed unnecessary files.


## [2020-02-09]

### Added

- Updates to README.md
- Updates to repo structure.

### Fixed

- Updates to `gerneratejson.py`. Fixed a bug where the bom file was being read incorrectly causing and error. Fixed a bug where some of the JSON information was not being serialized properly cause the bootstrap.json file to be created with errors.
    - Myself and a coworking of mine saw the same issue when running the original script with python 3.7.3.
    - I found the same result on vanilla installs of macOS and python3 as well.


## [2020-02-08]
### Added

- Added Python build process to `README.md`. Modified the instructions found [here](https://github.com/erikng/installapplications#building-embedded-python-framework)


### Changed

- Updated `.gitignore`

## [2020-02-08]
### Added

- This CHANGELOG to track progress through the build process
- `installapplications-2.0rc4` to the build packages used. Contains upgrades related to Python3 including the containing its own version of Python.
- Updates to the `README.md`
- Added a `README.md` to the packages directory.
- Latest version of `munkipkg`
- .gitignore file
- Basic repo structure to `README.md`
- Added the payload packages to the repository for distribution.


### Changed

- The size of the screenshots in the main `README.md` file to 450 x XXX pixels.
- The structure of this bootstrap repository.


### Removed

- `installapplications-1.2.3` and replaced it with the latest release


## [2020-02-07]
### Changed

- The bootstrap icon to a small size.


## [2019-08-09]
### Added

- Initial commit of bootstrap repo


## Unreleased aka "ToDo"

* Test and add enrollment [scripts](https://github.com/erikng/installapplications#downloading-and-running-scripts) to the bootstrap payload
* Test the bootstrap package
