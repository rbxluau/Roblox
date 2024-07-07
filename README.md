# Example
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/ScriptHub.lua"))()
```
## SupportedGames
* Arsenal
* Doors
* RaceClicker
* BladeBall
* RainbowFriends
* PrisonLife
# Library
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/rbxluau/Roblox/main/Library.lua"))()
```
## Window
```lua
local Window = Library:Window(<str>Name, <str?>Theme)
```
* Theme
    >dark
## Tab
```lua
local Tab = Window:Tab(<str> Name, <int?> Icon)
```
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
local Toggle = Section:Toggle(<str> Name, <str> Flag, <bool?> Enabled, <func?> Callback)
```
### SetState
```lua
Toggle:SetState(<bool?> State)
```
## Keybind
```lua
Section:Keybind(<str> Name, <str> Default, <func?> Callback)
```
## Textbox
```lua
Section:Textbox(<str> Name, <str> Flag, <str> Default, <func?> Callback)
```
## Slider
```lua
local Slider = Section:Slider(<str> Name, <str> Flag, <num?> Default, <num?> Min, <num?> Max, <bool?> Precise, <func?> Callback)
```
### SetValue
```lua
Slider:SetValue(<num?> Value)
```
## Dropdown
```lua
local Dropdown = Section:Dropdown(<str> Name, <str> Flag, <list?> Options, <func?> Callback)
```
### AddOption
```lua
Dropdown:AddOption(<str> Option)
```
### RemoveOption
```lua
Dropdown:RemoveOption(<str> Option)
```
### AddOptions
```lua
Dropdown:AddOptions(<list> Options)
```
