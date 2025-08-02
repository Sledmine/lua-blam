return {
    {
        address = "0x0",
        alignment = 4,
        is = "int",
        name = "widgetType",
        offset = 0,
        size = 2,
        type = "short",
        what = "field"
    },
    {
        address = "0x2",
        alignment = 4,
        is = "int",
        name = "controllerIndex",
        offset = 2,
        size = 2,
        type = "short",
        what = "field"
    },
    {
        address = "0x4",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                alignment = 1,
                is = "array",
                name = "string",
                offset = 0,
                size = 32,
                type = "array",
                what = "field"
            }
        },
        is = "struct",
        name = "name",
        offset = 4,
        size = 32,
        type = "String32",
        what = "field"
    },
    {
        address = "0x24",
        alignment = 2,
        fields = {
            {
                address = "0x0",
                alignment = 2,
                is = "int",
                name = "top",
                offset = 0,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x2",
                alignment = 2,
                is = "int",
                name = "left",
                offset = 2,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x4",
                alignment = 2,
                is = "int",
                name = "bottom",
                offset = 4,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x6",
                alignment = 2,
                is = "int",
                name = "right",
                offset = 6,
                size = 2,
                type = "short",
                what = "field"
            }
        },
        is = "struct",
        name = "bounds",
        offset = 36,
        size = 8,
        type = "Rectangle2D",
        what = "field"
    },
    {
        address = "0x2c",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "passUnhandledEventsToFocusedChild",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "pauseGameTime",
                offset = 4,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "flashBackgroundBitmap",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dpadUpDownTabsThruChildren",
                offset = 12,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dpadLeftRightTabsThruChildren",
                offset = 16,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dpadUpDownTabsThruListItems",
                offset = 20,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dpadLeftRightTabsThruListItems",
                offset = 24,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dontFocusASpecificChildWidget",
                offset = 28,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "passUnhandledEventsToAllChildren",
                offset = 32,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "renderRegardlessOfControllerIndex",
                offset = 36,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "passHandledEventsToAllChildren",
                offset = 40,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "returnToMainMenuIfNoHistory",
                offset = 44,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "alwaysUseTagControllerIndex",
                offset = 48,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "alwaysUseNiftyRenderFx",
                offset = 52,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "dontPushHistory",
                offset = 56,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "forceHandleMouse",
                offset = 60,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            }
        },
        is = "struct",
        name = "flags",
        offset = 44,
        size = 2,
        type = "UIWidgetDefinitionFlags",
        what = "field"
    },
    {
        address = "0x2e",
        alignment = 4,
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "passUnhandledEventsToFocusedChild",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "pauseGameTime",
                offset = 4,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "flashBackgroundBitmap",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dpadUpDownTabsThruChildren",
                offset = 12,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dpadLeftRightTabsThruChildren",
                offset = 16,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dpadUpDownTabsThruListItems",
                offset = 20,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dpadLeftRightTabsThruListItems",
                offset = 24,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dontFocusASpecificChildWidget",
                offset = 28,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "passUnhandledEventsToAllChildren",
                offset = 32,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "renderRegardlessOfControllerIndex",
                offset = 36,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "passHandledEventsToAllChildren",
                offset = 40,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "returnToMainMenuIfNoHistory",
                offset = 44,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "alwaysUseTagControllerIndex",
                offset = 48,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "alwaysUseNiftyRenderFx",
                offset = 52,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "dontPushHistory",
                offset = 56,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "forceHandleMouse",
                offset = 60,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            }
        },
        is = "int",
        name = "millisecondsToAutoClose",
        offset = 46,
        size = 4,
        type = "int",
        what = "field"
    },
    {
        address = "0x32",
        alignment = 4,
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "passUnhandledEventsToFocusedChild",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "pauseGameTime",
                offset = 4,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "flashBackgroundBitmap",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dpadUpDownTabsThruChildren",
                offset = 12,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dpadLeftRightTabsThruChildren",
                offset = 16,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dpadUpDownTabsThruListItems",
                offset = 20,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dpadLeftRightTabsThruListItems",
                offset = 24,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dontFocusASpecificChildWidget",
                offset = 28,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "passUnhandledEventsToAllChildren",
                offset = 32,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "renderRegardlessOfControllerIndex",
                offset = 36,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "passHandledEventsToAllChildren",
                offset = 40,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "returnToMainMenuIfNoHistory",
                offset = 44,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "alwaysUseTagControllerIndex",
                offset = 48,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "alwaysUseNiftyRenderFx",
                offset = 52,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "dontPushHistory",
                offset = 56,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x1",
                is = "int",
                name = "forceHandleMouse",
                offset = 60,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            }
        },
        is = "int",
        name = "millisecondsAutoCloseFadeTime",
        offset = 50,
        size = 4,
        type = "int",
        what = "field"
    },
    {
        address = "0x36",
        alignment = 8,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "tagGroup",
                offset = 0,
                size = 4,
                type = "int",
                what = "field"
            },
            {
                address = "0x8",
                alignment = 8,
                is = "ptr",
                name = "path",
                offset = 8,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x10",
                alignment = 8,
                is = "int",
                name = "pathSize",
                offset = 16,
                size = 8,
                type = "qword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x18",
                alignment = 4,
                is = "union",
                name = "tagHandle",
                offset = 24,
                size = 4,
                type = "TableResourceHandle",
                what = "field"
            }
        },
        is = "struct",
        name = "backgroundBitmap",
        offset = 54,
        size = 32,
        type = "TagReference",
        what = "field"
    },
    {
        address = "0x56",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "count",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x4",
                alignment = 8,
                is = "ptr",
                name = "elements",
                offset = 4,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0xc",
                alignment = 8,
                is = "ptr",
                name = "definition",
                offset = 12,
                size = 8,
                type = "ptr",
                what = "field"
            }
        },
        is = "struct",
        name = "gameDataInputs",
        offset = 86,
        size = 20,
        type = "struct",
        what = "field"
    },
    {
        address = "0x6a",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "count",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x4",
                alignment = 8,
                is = "ptr",
                name = "elements",
                offset = 4,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0xc",
                alignment = 8,
                is = "ptr",
                name = "definition",
                offset = 12,
                size = 8,
                type = "ptr",
                what = "field"
            }
        },
        is = "struct",
        name = "eventHandlers",
        offset = 106,
        size = 20,
        type = "struct",
        what = "field"
    },
    {
        address = "0x7e",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "count",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x4",
                alignment = 8,
                is = "ptr",
                name = "elements",
                offset = 4,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0xc",
                alignment = 8,
                is = "ptr",
                name = "definition",
                offset = 12,
                size = 8,
                type = "ptr",
                what = "field"
            }
        },
        is = "struct",
        name = "searchAndReplaceFunctions",
        offset = 126,
        size = 20,
        type = "struct",
        what = "field"
    },
    {
        address = "0x92",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "count",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x4",
                alignment = 8,
                is = "ptr",
                name = "elements",
                offset = 4,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0xc",
                alignment = 8,
                is = "ptr",
                name = "definition",
                offset = 12,
                size = 8,
                type = "ptr",
                what = "field"
            }
        },
        is = "array",
        name = "pad24420",
        offset = 146,
        size = 128,
        type = "array",
        what = "field"
    },
    {
        address = "0x112",
        alignment = 8,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "tagGroup",
                offset = 0,
                size = 4,
                type = "int",
                what = "field"
            },
            {
                address = "0x8",
                alignment = 8,
                is = "ptr",
                name = "path",
                offset = 8,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x10",
                alignment = 8,
                is = "int",
                name = "pathSize",
                offset = 16,
                size = 8,
                type = "qword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x18",
                alignment = 4,
                is = "union",
                name = "tagHandle",
                offset = 24,
                size = 4,
                type = "TableResourceHandle",
                what = "field"
            }
        },
        is = "struct",
        name = "textLabelUnicodeStringsList",
        offset = 274,
        size = 32,
        type = "TagReference",
        what = "field"
    },
    {
        address = "0x132",
        alignment = 8,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "tagGroup",
                offset = 0,
                size = 4,
                type = "int",
                what = "field"
            },
            {
                address = "0x8",
                alignment = 8,
                is = "ptr",
                name = "path",
                offset = 8,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x10",
                alignment = 8,
                is = "int",
                name = "pathSize",
                offset = 16,
                size = 8,
                type = "qword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x18",
                alignment = 4,
                is = "union",
                name = "tagHandle",
                offset = 24,
                size = 4,
                type = "TableResourceHandle",
                what = "field"
            }
        },
        is = "struct",
        name = "textFont",
        offset = 306,
        size = 32,
        type = "TagReference",
        what = "field"
    },
    {
        address = "0x152",
        alignment = 4,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "float",
                name = "a",
                offset = 0,
                size = 4,
                type = "float",
                what = "field"
            },
            {
                address = "0x4",
                alignment = 4,
                is = "float",
                name = "r",
                offset = 4,
                size = 4,
                type = "float",
                what = "field"
            },
            {
                address = "0x8",
                alignment = 4,
                is = "float",
                name = "g",
                offset = 8,
                size = 4,
                type = "float",
                what = "field"
            },
            {
                address = "0xc",
                alignment = 4,
                is = "float",
                name = "b",
                offset = 12,
                size = 4,
                type = "float",
                what = "field"
            }
        },
        is = "struct",
        name = "textColor",
        offset = 338,
        size = 16,
        type = "ColorARGB",
        what = "field"
    },
    {
        address = "0x162",
        alignment = 4,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "float",
                name = "a",
                offset = 0,
                size = 4,
                type = "float",
                what = "field"
            },
            {
                address = "0x4",
                alignment = 4,
                is = "float",
                name = "r",
                offset = 4,
                size = 4,
                type = "float",
                what = "field"
            },
            {
                address = "0x8",
                alignment = 4,
                is = "float",
                name = "g",
                offset = 8,
                size = 4,
                type = "float",
                what = "field"
            },
            {
                address = "0xc",
                alignment = 4,
                is = "float",
                name = "b",
                offset = 12,
                size = 4,
                type = "float",
                what = "field"
            }
        },
        is = "int",
        name = "justification",
        offset = 354,
        size = 2,
        type = "short",
        what = "field"
    },
    {
        address = "0x164",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "editable",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "password",
                offset = 4,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "flashing",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dontDoThatWeirdFocusTest",
                offset = 12,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            }
        },
        is = "struct",
        name = "flags1",
        offset = 356,
        size = 1,
        type = "UIWidgetDefinitionFlags1",
        what = "field"
    },
    {
        address = "0x165",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "editable",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "password",
                offset = 4,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "flashing",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dontDoThatWeirdFocusTest",
                offset = 12,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            }
        },
        is = "array",
        name = "pad24622",
        offset = 357,
        size = 12,
        type = "array",
        what = "field"
    },
    {
        address = "0x171",
        alignment = 2,
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "editable",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "password",
                offset = 4,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "flashing",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dontDoThatWeirdFocusTest",
                offset = 12,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            }
        },
        is = "int",
        name = "stringListIndex",
        offset = 369,
        size = 2,
        type = "word",
        unsigned = true,
        what = "field"
    },
    {
        address = "0x173",
        alignment = 2,
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "editable",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "password",
                offset = 4,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "flashing",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dontDoThatWeirdFocusTest",
                offset = 12,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            }
        },
        is = "int",
        name = "horizOffset",
        offset = 371,
        size = 2,
        type = "short",
        what = "field"
    },
    {
        address = "0x175",
        alignment = 2,
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "editable",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "password",
                offset = 4,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "flashing",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dontDoThatWeirdFocusTest",
                offset = 12,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            }
        },
        is = "int",
        name = "vertOffset",
        offset = 373,
        size = 2,
        type = "short",
        what = "field"
    },
    {
        address = "0x177",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "editable",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "password",
                offset = 4,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "flashing",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dontDoThatWeirdFocusTest",
                offset = 12,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            }
        },
        is = "array",
        name = "pad24729",
        offset = 375,
        size = 26,
        type = "array",
        what = "field"
    },
    {
        address = "0x191",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "editable",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "password",
                offset = 4,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "flashing",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "dontDoThatWeirdFocusTest",
                offset = 12,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            }
        },
        is = "array",
        name = "pad24753",
        offset = 401,
        size = 2,
        type = "array",
        what = "field"
    },
    {
        address = "0x193",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "listItemsGeneratedInCode",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "listItemsFromStringListTag",
                offset = 4,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "listItemsOnlyOneTooltip",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            },
            {
                address = "0x0",
                is = "int",
                name = "listSinglePreviewNoScroll",
                offset = 12,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "bitfield"
            }
        },
        is = "struct",
        name = "flags2",
        offset = 403,
        size = 1,
        type = "UIWidgetDefinitionFlags2",
        what = "field"
    },
    {
        address = "0x194",
        alignment = 8,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "tagGroup",
                offset = 0,
                size = 4,
                type = "int",
                what = "field"
            },
            {
                address = "0x8",
                alignment = 8,
                is = "ptr",
                name = "path",
                offset = 8,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x10",
                alignment = 8,
                is = "int",
                name = "pathSize",
                offset = 16,
                size = 8,
                type = "qword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x18",
                alignment = 4,
                is = "union",
                name = "tagHandle",
                offset = 24,
                size = 4,
                type = "TableResourceHandle",
                what = "field"
            }
        },
        is = "struct",
        name = "listHeaderBitmap",
        offset = 404,
        size = 32,
        type = "TagReference",
        what = "field"
    },
    {
        address = "0x1b4",
        alignment = 8,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "tagGroup",
                offset = 0,
                size = 4,
                type = "int",
                what = "field"
            },
            {
                address = "0x8",
                alignment = 8,
                is = "ptr",
                name = "path",
                offset = 8,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x10",
                alignment = 8,
                is = "int",
                name = "pathSize",
                offset = 16,
                size = 8,
                type = "qword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x18",
                alignment = 4,
                is = "union",
                name = "tagHandle",
                offset = 24,
                size = 4,
                type = "TableResourceHandle",
                what = "field"
            }
        },
        is = "struct",
        name = "listFooterBitmap",
        offset = 436,
        size = 32,
        type = "TagReference",
        what = "field"
    },
    {
        address = "0x1d4",
        alignment = 2,
        fields = {
            {
                address = "0x0",
                alignment = 2,
                is = "int",
                name = "top",
                offset = 0,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x2",
                alignment = 2,
                is = "int",
                name = "left",
                offset = 2,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x4",
                alignment = 2,
                is = "int",
                name = "bottom",
                offset = 4,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x6",
                alignment = 2,
                is = "int",
                name = "right",
                offset = 6,
                size = 2,
                type = "short",
                what = "field"
            }
        },
        is = "struct",
        name = "headerBounds",
        offset = 468,
        size = 8,
        type = "Rectangle2D",
        what = "field"
    },
    {
        address = "0x1dc",
        alignment = 2,
        fields = {
            {
                address = "0x0",
                alignment = 2,
                is = "int",
                name = "top",
                offset = 0,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x2",
                alignment = 2,
                is = "int",
                name = "left",
                offset = 2,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x4",
                alignment = 2,
                is = "int",
                name = "bottom",
                offset = 4,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x6",
                alignment = 2,
                is = "int",
                name = "right",
                offset = 6,
                size = 2,
                type = "short",
                what = "field"
            }
        },
        is = "struct",
        name = "footerBounds",
        offset = 476,
        size = 8,
        type = "Rectangle2D",
        what = "field"
    },
    {
        address = "0x1e4",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                alignment = 2,
                is = "int",
                name = "top",
                offset = 0,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x2",
                alignment = 2,
                is = "int",
                name = "left",
                offset = 2,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x4",
                alignment = 2,
                is = "int",
                name = "bottom",
                offset = 4,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x6",
                alignment = 2,
                is = "int",
                name = "right",
                offset = 6,
                size = 2,
                type = "short",
                what = "field"
            }
        },
        is = "array",
        name = "pad24950",
        offset = 484,
        size = 32,
        type = "array",
        what = "field"
    },
    {
        address = "0x204",
        alignment = 8,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "tagGroup",
                offset = 0,
                size = 4,
                type = "int",
                what = "field"
            },
            {
                address = "0x8",
                alignment = 8,
                is = "ptr",
                name = "path",
                offset = 8,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x10",
                alignment = 8,
                is = "int",
                name = "pathSize",
                offset = 16,
                size = 8,
                type = "qword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x18",
                alignment = 4,
                is = "union",
                name = "tagHandle",
                offset = 24,
                size = 4,
                type = "TableResourceHandle",
                what = "field"
            }
        },
        is = "struct",
        name = "extendedDescriptionWidget",
        offset = 516,
        size = 32,
        type = "TagReference",
        what = "field"
    },
    {
        address = "0x224",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "tagGroup",
                offset = 0,
                size = 4,
                type = "int",
                what = "field"
            },
            {
                address = "0x8",
                alignment = 8,
                is = "ptr",
                name = "path",
                offset = 8,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x10",
                alignment = 8,
                is = "int",
                name = "pathSize",
                offset = 16,
                size = 8,
                type = "qword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x18",
                alignment = 4,
                is = "union",
                name = "tagHandle",
                offset = 24,
                size = 4,
                type = "TableResourceHandle",
                what = "field"
            }
        },
        is = "array",
        name = "pad25020",
        offset = 548,
        size = 32,
        type = "array",
        what = "field"
    },
    {
        address = "0x244",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "tagGroup",
                offset = 0,
                size = 4,
                type = "int",
                what = "field"
            },
            {
                address = "0x8",
                alignment = 8,
                is = "ptr",
                name = "path",
                offset = 8,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x10",
                alignment = 8,
                is = "int",
                name = "pathSize",
                offset = 16,
                size = 8,
                type = "qword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x18",
                alignment = 4,
                is = "union",
                name = "tagHandle",
                offset = 24,
                size = 4,
                type = "TableResourceHandle",
                what = "field"
            }
        },
        is = "array",
        name = "pad25044",
        offset = 580,
        size = 256,
        type = "array",
        what = "field"
    },
    {
        address = "0x344",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "count",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x4",
                alignment = 8,
                is = "ptr",
                name = "elements",
                offset = 4,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0xc",
                alignment = 8,
                is = "ptr",
                name = "definition",
                offset = 12,
                size = 8,
                type = "ptr",
                what = "field"
            }
        },
        is = "struct",
        name = "conditionalWidgets",
        offset = 836,
        size = 20,
        type = "struct",
        what = "field"
    },
    {
        address = "0x358",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "count",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x4",
                alignment = 8,
                is = "ptr",
                name = "elements",
                offset = 4,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0xc",
                alignment = 8,
                is = "ptr",
                name = "definition",
                offset = 12,
                size = 8,
                type = "ptr",
                what = "field"
            }
        },
        is = "array",
        name = "pad25198",
        offset = 856,
        size = 128,
        type = "array",
        what = "field"
    },
    {
        address = "0x3d8",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "count",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x4",
                alignment = 8,
                is = "ptr",
                name = "elements",
                offset = 4,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0xc",
                alignment = 8,
                is = "ptr",
                name = "definition",
                offset = 12,
                size = 8,
                type = "ptr",
                what = "field"
            }
        },
        is = "array",
        name = "pad25223",
        offset = 984,
        size = 128,
        type = "array",
        what = "field"
    },
    {
        address = "0x458",
        alignment = 1,
        fields = {
            {
                address = "0x0",
                alignment = 4,
                is = "int",
                name = "count",
                offset = 0,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0x4",
                alignment = 8,
                is = "ptr",
                name = "elements",
                offset = 4,
                size = 8,
                type = "ptr",
                what = "field"
            },
            {
                address = "0xc",
                alignment = 8,
                is = "ptr",
                name = "definition",
                offset = 12,
                size = 8,
                type = "ptr",
                what = "field"
            }
        },
        is = "struct",
        name = "childWidgets",
        offset = 1112,
        size = 20,
        type = "struct",
        what = "field"
    }
}
