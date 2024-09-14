# LuaU-Disassembler
Disassembles LuaU code using bytecode

# Usage
```lua
local import = function(file)
  return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/playvoras/LuaU-Disassembler-fixed/main/%s.lua"):format(file)), file .. ".lua")()
end

local opCodes = import("opCodes")
local deserialize = import("deserialize")
local disassemble = import("disassemble")
local scriptPath = nil --> script path goes here <--

local success, result = pcall(disassemble, deserialize(getscriptbytecode(scriptPath), getfenv(1)), 0, opCodes)
assert(success, result)
print(result)
```
