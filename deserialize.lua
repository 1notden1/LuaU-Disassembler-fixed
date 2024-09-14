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

    local function readVarInt()
        local result, shift, byte = 0, 0

        repeat
            byte = gBits8()
            result = result + bit.lshift(bit.band(byte, 127), shift)
            shift = shift + 7
        until bit.band(byte, 128) == 0

        return result
    end

    local function gString()
        local len = readVarInt()
        local ret = string.sub(bytecode, offset, offset + len - 1)
        offset = offset + len
        return ret
    end

    local version = gBits8()
    print(version)
    assert(version == 5, "bytecode version mismatch")

    local strings = {}
    local stringCount = readVarInt()
    for i = 1, stringCount do
        strings[i] = gString()
    end

    local instructions = {}
    local instructionCount = readVarInt()
    for i = 1, instructionCount do
        local opcode = gBits8()
        instructions[i] = opcode
    end

    return instructions
end

return Deserialize
