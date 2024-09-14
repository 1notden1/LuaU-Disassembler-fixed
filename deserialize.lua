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
    print("Bytecode version: ", version)
    assert(version == 5 or version == 6, "bytecode version mismatch")

    local strings = {}
    local stringCount = readVarInt()
    for i = 1, stringCount do
        strings[i] = gString()
    end

    local instructions = {}
    local instructionCount = readVarInt()
    for i = 1, instructionCount do
        local opcode = gBits8()
        if version == 6 then
            local additionalData = gBits8()
            instructions[i] = {opcode = opcode, extra = additionalData}
        else
            instructions[i] = opcode
        end
    end

    return instructions
end

return Deserialize
