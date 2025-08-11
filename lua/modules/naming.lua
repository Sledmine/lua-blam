-- SPDX-License-Identifier: GPL-3.0-only

-- https://gist.github.com/MangoFizz/2f311ae13b3bd77f3143028c0543b85b

local exceptions = {}

local function addExceptions(newExceptions)
    for _, exception in ipairs(newExceptions) do
        table.insert(exceptions, exception)
    end
    table.sort(exceptions, function(a, b) return #a > #b end)
end

local accentMap = {
    ["á"] = "a", ["é"] = "e", ["í"] = "i", ["ó"] = "o", ["ú"] = "u",
    ["Á"] = "A", ["É"] = "E", ["Í"] = "I", ["Ó"] = "O", ["Ú"] = "U",
    ["ñ"] = "n", ["Ñ"] = "N"
}

local function sanitizeInput(input)
    input = input:gsub("[áéíóúÁÉÍÓÚñÑ]", function(c) return accentMap[c] or c end)
    input = input:gsub("[^%w%s%-_]", "")
    return input
end

local function splitWords(rawInput)
    local input = sanitizeInput(rawInput)
    local words = {}
    local buffer = ""
    local length = #input
    local i = 1

    while i <= length do
        local foundException = nil

        -- Check if an exception starts at the current position
        for _, exception in ipairs(exceptions) do
            if input:sub(i, i + #exception - 1) == exception then
                foundException = exception
                break
            end
        end

        if foundException then
            -- If there was something in the buffer, add it as a normal word
            if buffer ~= "" then
                table.insert(words, buffer:lower())
                buffer = ""
            end
            -- Add the exception as a single word
            table.insert(words, foundException)
            i = i + #foundException -- Skip the entire exception
        else
            local char = input:sub(i, i)
            local nextChar = input:sub(i + 1, i + 1)

            -- Handle separators
            if char:match("[%s%-%_]") then
                if buffer ~= "" then
                    table.insert(words, buffer:lower())
                    buffer = ""
                end
            -- Handle case changes and numbers without separating exceptions
            elseif buffer ~= "" and (
                (char:match("%u") and nextChar:match("%l")) or  -- Case "Ab"
                (char:match("%l") and nextChar:match("%u")) or  -- Case "aB"
                (char:match("%d") and nextChar:match("%a")) or  -- Case "3x"
                (char:match("%a") and nextChar:match("%d"))     -- Case "x3"
            ) then
                buffer = buffer .. char
                table.insert(words, buffer:lower())
                buffer = ""
            else
                buffer = buffer .. char
            end

            i = i + 1
        end
    end

    -- Add the last fragment if there is something in the buffer
    if buffer ~= "" then
        table.insert(words, buffer:lower())
    end

    return words
end

local function toPascalCase(input)
    local words = splitWords(input)
    for i = 1, #words do
        words[i] = words[i]:sub(1, 1):upper() .. words[i]:sub(2)
    end
    return table.concat(words)
end

local function toCamelCase(input)
    local words = splitWords(input)
    for i = 2, #words do
        words[i] = words[i]:sub(1, 1):upper() .. words[i]:sub(2)
    end
    return table.concat(words)
end

local function toSnakeCase(input)
    local words = splitWords(input)
    return table.concat(words, "_"):lower()
end

local function toKebabCase(input)
    local words = splitWords(input)
    return table.concat(words, "-")
end

local function toSentenceCase(input)
    local words = splitWords(input)
    words[1] = words[1]:sub(1, 1):upper() .. words[1]:sub(2)
    return table.concat(words, " ")
end

return {
    addExceptions = addExceptions,
    toPascalCase = toPascalCase,
    toCamelCase = toCamelCase,
    toSnakeCase = toSnakeCase,
    toKebabCase = toKebabCase,
    toSentenceCase = toSentenceCase
}