# Isometric 2D Game Engine 
Made with the Love2D game template by Keyslam. 

## Model (currently under development) 
### Scene Composition
The Scene follows a sort of composite pattern by maintaining a list of components. Components are currently all "leaf" components, in that the abstract component class does not maintain its own list of components to delegate events to. The Scene delegates Love events to the components. 
### Components
#### Tile
Class which forms the tile grid. 
#### Mouse
Listens for mouse events to attach images for tile editing, placing tiles, removing tiles.
#### Grid
The class which draws and maintains the tile grid.
#### Gui
Uses ImGui.so to have a tile picker menu to draw tiles. Tile drawing supports dragging the mouse left click to add tiles, and right click to remove tiles. The Imgui.so is platform dependent, but can compile your own .so for your computer's architecture. 
#### Buttons
Generic button class following the command pattern to invoke a button and execute the supplied button function. 
## Math2 
Uses a small Math2D package to perform isometric matrix transforms and simple vector operations to translate betweeen cartesian grid coordinates and isometric screen coordinates.
