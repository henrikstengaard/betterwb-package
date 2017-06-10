# BetterWB Package

BetterWB is an enhancement built for Workbench 3.1 by Gulliver for low end Amigas restricted to 68000 processors.

## Description

BetterWB is a new workbench pack, much like AIAB, Amikit, AmigaSYS, ClassicWB, etc. but applying a totally different aproach. It aims to be much like an enhancement, an updated extension to AmigaOS 3.1, without all those hardware requirement penalties typically associated with these kind of packs. It is indeed a better 3.1 than 3.1 itself!

BetterWB has been converted to a package for HstWB Installer.

Original version of BetterWB can be downloaded from http://lilliput.amiga-projects.net/BetterWB.htm.

**BetterWB best targets:**

- Purists that believe anything beyond 3.1 is an overbloated piece of crap.
- Low end Amiga computers that are left in storage deprived from any usage, and only regarded as antiques.
- Users that refuse to pay big bucks in order to be able to somehow upgrade their Amiga workbench experience.
- Minimig users, that are restricted to a 68000 processor.
- Anyone that wishes a clean AmigaOS 3.1 like experience.

**Advantages:**

- Works on any Amiga.
- It occupies less than 10MB on a harddrive.
- It is distributed as a set of floppy images.
- Its usage is simple and bares a high resemblance to an ordinary 3.1 install.

**Drawbacks:**

- Limited eye candy (but it does not compromise performance).
- Will appear incomplete, for high end or heavily expanded Amiga systems (They are probably better with other workbench packs), that rely on visual appealing components.

## Requirements

BetterWB package can be installed on any Amiga with Workbench 3.1 and about 10MB free space on a harddrive for installation.

## Installation

Download latest release from https://github.com/henrikstengaard/betterwb-package/releases and copy it to HstWB Installer "packages" directory, which typically is "c:\Program Files (x86)\HstWB Installer\Packages".

Installation through HstWB Installer will install and configure BetterWB package using defined assigns.

## Assigns

Installation of BetterWB package requires and uses following assign and default value:

- SYSTEMDIR: = DH0:

BetterWB files will be installed and configured in SYSTEMDIR: assign, which must be set to harddrive containing Workbench.

## Modifications

BetterWB is installed from a zip files copied from BetterWB adf files.

The install script for BetterWB Installer is based on S/Startup-Sequence from MISC31_#1.adf with following changes:

- Paths has been changed: SYS: to SYSTEMDIR:.
- Removed waits for next floppy.
- Removed ENV-HANDLER patch.

## Screenshots

Screenshots of BetterWB package.

![BetterWB 1](screenshots/betterwb_1.png?raw=true)

![BetterWB 2](screenshots/betterwb_2.png?raw=true)

![BetterWB 3](screenshots/betterwb_3.png?raw=true)

![BetterWB 4](screenshots/betterwb_4.png?raw=true)

![BetterWB 5](screenshots/betterwb_5.png?raw=true)