# List of community patches
_Here's a list of patches that have been applied, in no particular order, grouped by patch type._

## Fixes
- [Improved camera handling script](https://www.nesmakers.com/index.php?threads/lets-improve-scrolling-together-4-5-9-dohandlecamera-updates-fixes.7929/), by SciNEStist
  - Modified to work with both two-way and one-way scrolling modules, by Smile Hero
  - Applies [Scrolling platformer seam collision fix](https://www.nesmakers.com/index.php?threads/scrolling-platformer-seam-collision-fix-4-5-9.7266/), by TakuikaNinja & Dale Coop
  - [Adjust the speed of your ship along with the scrolling](https://www.nesmakers.com/index.php?threads/lets-improve-scrolling-together-4-5-9-dohandlecamera-updates-fixes.7929/page-4#post-48125), by SciNEStist
- [Vertical movement re-added for platformer modules](https://www.nesmakers.com/index.php?threads/vertical-movement-ai-for-enemies-in-metroidvania-project.7841/)
- [Column of black tiles glitch in Metroidvania fix](https://www.nesmakers.com/index.php?threads/row-of-black-tiles-metrovania-4-5-9.8728/), by Board-B
- [Abrupt stop when player collides with solid above fix](https://www.nesmakers.com/index.php?threads/4-5-9-physics-script-help-abrupt-stop-when-player-collides-with-solid-above.7133/#post-52144), by Jonny & Rusty Retro Entertainment System
- [Fix to invisible hurt on the player](https://www.nesmakers.com/index.php?threads/enemies-falling-off-ledges-on-the-left-side-cause-player-to-die-in-platformer.6969/page-2), by CluckFox
- [Improved ladder script](https://www.nesmakers.com/index.php?threads/mega-man-style-ladders-4-5-9-platform-module-updated.7805/), by Board-B & Smile Hero
- [Minor bugfix for metrovania projectile initialization](https://www.nesmakers.com/index.php?threads/4-5-6-minor-bugfix-for-metrovania-projectile-initialization.5883/), by TakuikaNinja
- [Prevent button mashing during text boxes](https://www.nesmakers.com/index.php?threads/4-5-9-prevent-button-mashing-during-text-boxes.8424/), by Dale Coop
- [Quick fix for the 1st background/sprite color palette issue](https://www.nesmakers.com/index.php?threads/4-5-quick-fix-for-the-1st-background-sprite-color-palette-issue.5474/), by Dale Coop
- [EndAnimation working with 8 frame animations](https://www.nesmakers.com/index.php?threads/4-5-9-end-animation-not-working-with-8-frame-animations-fix.7557/), by Dale Coop
- [Textboxes don't cancel paths](https://www.nesmakers.com/index.php?threads/4-5-9-fix-for-the-the-paths-and-text-box-issue.7697/), by Dale Coop
- [Prize tile not always disappearing fix](https://www.nesmakers.com/index.php?threads/prize-tile-not-always-dissappearing-4-5-9.7643/), by m8si
- Stop player movement after WarpToScreen
- [Walking in place when landing fix](https://www.nesmakers.com/index.php?threads/walking-in-place-when-landing-platformer-metrovania-4-5-9.8417/), by Board-B
- [Reduce graphical glitches after warping without buffer screens](https://www.nesmakers.com/index.php?threads/4-5-x-how-to-fix-graphical-glitches-after-warping-without-buffer-screens.7295/#post-40092), by Dale Coop
  - [Free some space and reduce glitched tiles in scrolling modules](https://www.nesmakers.com/index.php?threads/4-5-9-updated-method-for-freeing-some-space-reduce-glitched-tiles-in-scrolling-modules.8657/), by Smile Hero
  - [Half-metatile not drawing on screen load fix](http://www.nesmakers.com/index.php?threads/4-5-x-how-to-fix-graphical-glitches-after-warping-without-buffer-screens.7295/post-55979)
- [Update multiple HUD elements simultaneously](https://www.nesmakers.com/index.php?threads/update-multiple-hud-elements-simultaneously-4-5-9.8360/), by Dale Coop
- [Monster weapons collision restored](https://www.nesmakers.com/index.php?threads/4-5-9-bring-back-monster-weapons-maze-module-and-others.5966/), by TolerantX / NightMusic
- [Fix button mashing during text boxes](https://www.nesmakers.com/index.php?threads/4-5-9-prevent-button-mashing-during-text-boxes.8424/), by Dale Coop
- [MetroidVania jumping up screen issue fix](https://www.nesmakers.com/index.php?threads/4-5-6-metroidvania-jumping-up-screen-issue-solved.6246/), by goatgary
- [Triggered Screen Song not Playing](https://www.nesmakers.com/index.php?threads/solved-4-5-9-arcadeplatformer-song-when-triggered-screen.7408/), by Dale Coop
- Acceleration/Inertia bugs (IN PROGRESS - only fixed in Adventure, Maze and LR Platformer)
- Landing bump in Platformer modules
- Fall and Walk animation overlap in Platformer modules
- Variable Jump cutting trampoline's vertical speed

## Quality of life changes
- Moved values from script files to the user interface
- Added UI option to hide the sprite HUD by default
- Simplified inputs for all modules, by crazygrouptrio and B-Board
- Removed unused constants
- Moved timer end scripts and special text character scripts to separate files to increase engine flexibility
- Refactoring of script files (work in progress)
- Hard coded constants moved to UI for more customization
- Player Action States, Tile Type numbers, Physics Values, etc. are defined by constants that can be modified in the UI

## Optimizations
- [Optimized doGetRandomNumber](https://www.nesmakers.com/index.php?threads/improving-dogetrandomnumber.7927/), by TakuikaNinja
- [Move doLoadScreen to Bank 16](https://www.nesmakers.com/index.php?threads/4-5-x-move-doloadscreen-to-bank-16.7019/) (saves 17% of static bank space), by JamesNES
- More space in overflow RAM by deleting unnecessary bytes (saves 5-18 bytes in RAM)
  - Path bytes on scrolling modules
  - Bytes related to an unused camera system
  - Recoil bytes that are never used in code
- More space in Zero Page RAM by deleting unnecessary bytes (saves 2 bytes in ZP)
- ROM space optimization in Bank18 (saves 192 bytes in ROM)
- NMI optimization by removing unnecessary pushes (saves at least 192 bytes in the static bank)
- Remove trigger initialization by default (saves 128 bytes in the static bank)

## Added content
- UntriggerScreen macro, by Dale Coop
- CountObjectType macro, by Board-B
- ChangeTileAtPosition macro, by Dale Coop and Board-B
- [FlashScreen macro](https://www.nesmakers.com/index.php?threads/flash-screen-macro-4-5-9.6960/), by crazygrouptrio
- Input presets for all modules
- [Non-textbox pause script](https://www.nesmakers.com/index.php?threads/4-5-6-non-textbox-pause-script.6339/), by CutterCross
  - Plus an [alternative](https://www.nesmakers.com/index.php?threads/4-5-non-textbox-based-pause.5421/), by Dale Coop
- [Variable gravity per screen type](https://www.nesmakers.com/index.php?threads/have-different-gravity-on-specific-screen-types-4-5-9.7242/#post-49139), by Board-B
- Diagonal movement options for the Adventure module
- Added variable to limit projectiles per screen
- [Arbitrary Bankswitch](https://www.nesmakers.com/index.php?threads/arbitrary-bankswitch.8271/), by JamesNES
- 6-point and 8-point versions of the tile collision routine
- [Monster Bits - No RAM method](https://www.nesmakers.com/index.php?threads/4-5-9-adding-monster-bits-back-in.7682/), by JamesNES
