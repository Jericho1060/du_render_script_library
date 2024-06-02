# du_render_script_library

A library to build renderscript in boards without writting it as a full string

The goal of that lib is to make RenderScript easier to write and read when written un control units and not directly in screens.

## Project status

This project is currently in developpement and not finished yet.

I'm currently looking for feedbacks and ideas to improve it and fix some limitations like how to render a function or loop or condition in the render script.

## Discord Server

You can join me on Discord for help or suggestions or requests by following that link : https://discord.gg/qkdjyqDZQZ

## How to use it

Paste all the content of the library (prefer the minified version) at the start of your script in a control unit in game and then you can use it like this:

```lua
local script = setmetatable({},RenderScript)
local MyFirstLayer = script:createLayer()
script:addBox(MyFirstLayer,0,0,100,100)

if not script:isTooLong() then
    script:sendToScreen(screen)
else
    system.print("WARNING: Script too long!! Length is actualy " .. script:len() .. " / " .. script:getMaxSize())
end

```

## Code before

Code was all formated as a string and was hard to read, write and debug

```lua
local script = [[
    local MyFirstLayer = createLayer()
    addBox(MyFirstLayer, 0, 0, 100, 100)
]]

screen.setRenderScript(script)
```

## Addition to the default render script

This library add some functions to the default render script:

### Third Party libraries support

`use(libraryName)`: Use a third party library in the renderscript
- `libraryName`: `string` The name of the library to use, it will also be used as the variable name to access it in the renderScript

`useAtlas()`: Use the atlas library in the renderscript

`useJSON()`: Use the JSON (dkjson) library in the renderscript

`useRSLib()`: Use the RSLib library in the renderscript

### RenderScript utilities functions

`getMaxSize()`: Get the maximum size of the render script

`isTooLong()`: Check if the render script is too long

`sendToScreen(screen)`: Send the render script to a screen

### Others

`insertCodeLine(code)`: Insert a line of code in the render script
