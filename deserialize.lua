--[[ 
                                             Copyright 2024 - kkeyy

 All rights reserved. This Lua code is the intellectual property of kkeyy and is protected by copyright laws and international treaties. 
 Unauthorized use, reproduction, or distribution of this code, in whole or in part, without the prior written consent of kkeyy, is strictly prohibited.
 This code is provided "as is" without any warranty, express or implied, including but not limited to the implied warranties of merchantability and fitness for a particular purpose. 
 kkeyy shall not be liable for any direct, indirect, incidental, special, exemplary, or consequential damages (including, but not limited to, procurement of substitute goods or services; loss of use, data, or profits; or business interruption) however caused and on any theory of liability, whether in contract, strict liability, or tort (including negligence or otherwise) arising in any way out of the use of this code, even if advised of the possibility of such damage.
 For inquiries regarding licensing, customization, or any other use of this code, please contact kkeyy at admin@kkeyy.lol.
]]--

local function Deserialize(bytecode)
    local offset = 1

    local function gBits8() 
        local b = string.byte(bytecode, offset, offset)
        offset = offset + 1
        return b
    end

    local self = {}  -- Create a table to hold methods

   local function self:nextByte()
        return gBits8()  -- Get the next byte from the bytecode
    end

    function self:nextVarInt()
        local result = 0
        for i = 0, 4 do
            local b = self:nextByte()
            result = bit32.bor(result, bit32.lshift(bit32.band(b, 0x7F), i * 7))
            if not bit32.btest(b, 0x80) then
                break
            end
        end
        return result
    end

    local function gString()
        local len = self:nextVarInt()  -- Use nextVarInt to get the length
        local ret = string.sub(bytecode, offset, offset + len - 1)
        offset = offset + len
        return ret
    end

    -- Check the version
    local version = gBits8()
    print(version)
    assert(version == 6, "bytecode version mismatch")

    -- Read string count
    local strings = {}
    local stringCount = self:nextVarInt()
    for i = 1, stringCount do
        strings[i] = gString()
    end

    -- Read instructions
    local instructions = {}
    local instructionCount = self:nextVarInt()
    for i = 1, instructionCount do
        local opcode = self:nextByte()  -- Use self:nextByte() here
        instructions[i] = opcode
    end

    return instructions
end

return Deserialize
