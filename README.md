# Example
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/ScriptHub.lua"))()
```
* SupportedGames
    > Arsenal  
    Doors  
    RaceClicker  
    BladeBall  
    RainbowFriends  
    PrisonLife
# Library
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()
```
## Window
```lua
local Window = Library:Window(<str> Name, <str?> Theme)
```
* Theme
    > dark
### Destroy
```lua
Window:Destroy()
```
### Toggle
```lua
Window:Toggle()
```
## Tab
```lua
local Tab = Window:Tab(<str> Name, <int?> Icon)
```
[Lucide Icons](https://github.com/frappedevs/lucideblox)
## Section
```lua
local Section = Tab:Section(<str> Name, <bool?> Enabled)
```
## Button
```lua
Section:Button(<str> Name, <func?> Callback)
```
## Label
```lua
Section:Label(<str> Name)
```
## Toggle
```lua
local Toggle = Section:Toggle(<str> Name, <str> Flag, <bool?> Enabled, <func?<bool>> Callback)
```
### SetState
```lua
Toggle:SetState(<bool?> State)
```
## Keybind
```lua
Section:Keybind(<str> Name, <str> Default, <func?<str>> Callback)
```
## Textbox
```lua
Section:Textbox(<str> Name, <str> Flag, <str> Default, <func?<str>> Callback)
```
## Slider
```lua
local Slider = Section:Slider(<str> Name, <str> Flag, <num?> Default, <num?> Min, <num?> Max, <bool?> Precise, <func?<num>> Callback)
```
### SetValue
```lua
Slider:SetValue(<num?> Value)
```
## Dropdown
```lua
local Dropdown = Section:Dropdown(<str> Name, <str> Flag, <list?<str>> Options, <func?<str>> Callback)
```
### AddOption
```lua
Dropdown:AddOption(<str> Option)
```
### RemoveOption
```lua
Dropdown:RemoveOption(<str> Option)
```
### SetOptions
```lua
Dropdown:SetOptions(<list<str>> Options)
```
## FAQ
### How flags work?
The flags feature in the ui may be confusing for some people. It serves the purpose of being the ID of an element in the config file, and makes accessing the value of an element anywhere in the code possible. Below in an example of using flags.
```lua
Library.flags["name"]
```
## Tip
Use the <kbd>LeftControl</kbd> or <img src=https://raw.githubusercontent.com/frappedevs/lucideblox/master/icons/expand.png width=30 /> to toggle UI.
