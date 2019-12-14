# forward_gestures_livewallpaper

Flutter testing wallpaper options

Soon will be a plugin for android

### TODO

- [x] Wallpaper change event
- [x] Wallpaper scroll
  - [x] Pageview
  - [ ] Genrealize the methods
- [x] Get wallpaper Colors
- [ ] Wallpapar OnColorChanged
  - [ ] add/remove listeners
- [x] LiveWallpaper click through
  - [x] Forward gestures to live wallpaper
    - [ ] What is a secondary tap (?)
- [ ] Add the functionalities added in github/phanirithvij/BasicLauncher
  - [ ] Open LiveWallpaper picker
  - [ ] Open Wallpaper picker to set wallpaper (Intent.ACTION_SET_WALLPAPER)
  - [ ] Open Current live wallpaper's settings activity (if it exists)
- [ ] Set a ImageProvider as wallpaper
  - [ ] Convert image to binary
  - [ ] Send it using methodchannel
  - [ ] make it a drawable
  - [ ] Open activity to set it as a wallpaper
  - [ ] Crop and set wallpaper
- [ ] Get all the info from a live wallpaper
  - [ ] authors, description
  - [ ] Create a WallpaperInfo model in dart
- [ ] Crop on dart side (?)
- [ ] Get the list of live wallpaper providers
- [ ] Get the list of apps that can set a wallpaper
- [ ] Convert to BLOC instead of provider
- [ ] Make this a plugin
  - [ ] Change the name
  - [ ] Make this the example app to show how all the methods can be used
- [ ] Start working on desktop
  - [ ] Windows
  - [ ] Linux
  - [ ] MacOs : Contributions welcome
  - [ ] IOS : WON'T BE DONE
