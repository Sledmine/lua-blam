local luna = {
    _VERSION = "0.0.1",
}

luna.string = {}

--- Split a string into a table of substrings by `sep`.
---@param s string
---@param sep string
---@return string[]
---@nodiscard
function luna.string.split(s, sep)
    assert(s ~= nil, "string.split: s must not be nil")
    local fields = {}
    local pattern = string.format("([^%s]+)", sep)
    local _ = s:gsub(pattern, function(c)
        fields[#fields + 1] = c
    end)
    return fields
end

--- Return a string with all leading whitespace removed.
---@param s string
---@return string
---@nodiscard
function luna.string.ltrim(s)
    assert(s ~= nil, "string.ltrim: s must not be nil")
    return s:match "^%s*(.-)$"
end

--- Return a string with all trailing whitespace removed.
---@param s string
---@return string
---@nodiscard
function luna.string.rtrim(s)
    assert(s ~= nil, "string.rtrim: s must not be nil")
    return s:match "^(.-)%s*$"
end

--- Return a string with all leading and trailing whitespace removed.
---@param s string
---@return string
---@nodiscard
function luna.string.trim(s)
    assert(s ~= nil, "string.trim: s must not be nil")
    -- return s:match "^%s*(.-)%s*$"
    return luna.string.ltrim(luna.string.rtrim(s))
end

--- Return a string with all ocurrences of `pattern` replaced with `replacement`.
---
--- **NOTE**: Pattern is a plain string, not a Lua pattern. Use `string.gsub` for Lua patterns.
---@param s string
---@param pattern string
---@param replacement string
---@return string
---@nodiscard
function luna.string.replace(s, pattern, replacement)
    assert(s ~= nil, "string.replace: s must not be nil")
    assert(pattern ~= nil, "string.replace: pattern must not be nil")
    assert(replacement ~= nil, "string.replace: replacement must not be nil")
    local pattern = pattern:gsub("%%", "%%%%"):gsub("%z", "%%z"):gsub("([%^%$%(%)%.%[%]%*%+%-%?])",
                                                                      "%%%1")
    local replaced, _ = s:gsub(pattern, replacement)
    return replaced
end

-- Add string methods to string metatable
string.split = luna.string.split
string.ltrim = luna.string.ltrim
string.rtrim = luna.string.rtrim
string.trim = luna.string.trim
string.replace = luna.string.replace

luna.table = {}

--- Return a deep copy of a table.
---@generic T
---@param t T
---@return T
---@nodiscard
function luna.table.copy(t)
    assert(t ~= nil, "table.copy: t must not be nil")
    local u = {}
    for k, v in pairs(t) do
        u[k] = type(v) == "table" and luna.table.copy(v) or v
    end
    return setmetatable(u, getmetatable(t))
end

--- Find and return first index of `value` in `t`.
---@generic V
---@param t table<number, V>: { [number]: V }
---@param value V
---@return number?
---@nodiscard
function luna.table.indexof(t, value)
    assert(t ~= nil, "table.find: t must not be nil")
    assert(type(t) == "table", "table.find: t must be a table")
    for i, v in ipairs(t) do
        if v == value then
            return i
        end
    end
end

-- TODO Check annotations, it seems like flipping a table key pairs with generics doesn't work.
--- Return a table with all keys and values swapped.
---@generic K, V
---@param t table<K, V>
---@return table<V, K>
---@nodiscard
function luna.table.flip(t)
    assert(t ~= nil, "table.flip: t must not be nil")
    assert(type(t) == "table", "table.flip: t must be a table")
    local u = {}
    for k, v in pairs(t) do
        u[v] = k
    end
    return u
end

--- Returns the first element of `t` that satisfies the predicate `f`.
---@generic K, V
---@param t table<K, V>
---@param f fun(v: V, k: K): boolean
---@return V?
---@nodiscard
function luna.table.find(t, f)
    assert(t ~= nil, "table.find: t must not be nil")
    assert(type(t) == "table", "table.find: t must be a table")
    assert(f ~= nil, "table.find: f must not be nil")
    assert(type(f) == "function", "table.find: f must be a function")
    for k, v in pairs(t) do
        if f(v, k) then
            return v
        end
    end
end

--- Returns a list of all keys in `t`.
---@generic K, V
---@param t table<K, V>
---@return K[]
---@nodiscard
function luna.table.keys(t)
    assert(t ~= nil, "table.keys: t must not be nil")
    assert(type(t) == "table", "table.keys: t must be a table")
    local keys = {}
    for k in pairs(t) do
        keys[#keys + 1] = k
    end
    return keys
end

--- Returns a table with all elements of `t` that satisfy the predicate `f`.
--- 
--- **NOTE**: It keeps original keys in the new table.
---@generic K, V
---@param t table<K, V>
---@param f fun(v: V, k: K): boolean
---@return table<K, V>
---@nodiscard
function luna.table.filter(t, f)
    assert(t ~= nil, "table.filter: t must not be nil")
    assert(type(t) == "table", "table.filter: t must be a table")
    assert(f ~= nil, "table.filter: f must not be nil")
    assert(type(f) == "function", "table.filter: f must be a function")
    local filtered = {}
    for k, v in pairs(t) do
        if f(v, k) then
            filtered[k] = v
        end
    end
    return filtered
end

-- Add table methods to table functions
table.copy = luna.table.copy
table.indexof = luna.table.indexof
table.flip = luna.table.flip
table.find = luna.table.find
table.keys = luna.table.keys
table.filter = luna.table.filter

return luna
