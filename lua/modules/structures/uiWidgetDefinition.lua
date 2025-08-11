return {
    {
        address = "0x0",
        is = "int",
        name = "widgetType",
        offset = 0,
        size = 2,
        type = "short",
        what = "field"
    },
    {
        address = "0x2",
        is = "int",
        name = "controllerIndex",
        offset = 2,
        size = 2,
        type = "short",
        what = "field"
    },
    {
        address = "0x4",
        fields = {
            {
                address = "0x0",
                count = 32,
                elementSize = 1,
                elementType = "char",
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
        type = "struct",
        what = "field"
    },
    {
        address = "0x24",
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "top",
                offset = 0,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x2",
                is = "int",
                name = "left",
                offset = 2,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x4",
                is = "int",
                name = "bottom",
                offset = 4,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x6",
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
        type = "struct",
        what = "field"
    },
    {
        address = "0x2c",
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
        size = 4,
        type = "struct",
        what = "field"
    },
    {
        address = "0x30",
        is = "int",
        name = "millisecondsToAutoClose",
        offset = 48,
        size = 4,
        type = "int",
        what = "field"
    },
    {
        address = "0x34",
        is = "int",
        name = "millisecondsAutoCloseFadeTime",
        offset = 52,
        size = 4,
        type = "int",
        what = "field"
    },
    {
        address = "0x38",
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "tagGroup",
                offset = 0,
                size = 4,
                type = "int",
                what = "field"
            },
            {
                address = "0x4",
                count = 4,
                elementSize = 1,
                elementType = "char",
                is = "ptr",
                name = "path",
                offset = 4,
                size = 4,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x8",
                is = "int",
                name = "pathSize",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0xc",
                is = "union",
                name = "tagHandle",
                offset = 12,
                size = 4,
                type = "union",
                what = "field"
            }
        },
        is = "struct",
        name = "backgroundBitmap",
        offset = 56,
        size = 16,
        type = "struct",
        what = "field"
    },
    {
        address = "0x48",
        fields = {
            {
                address = "0x0",
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
                count = 0,
                elementSize = 36,
                is = "ptr",
                name = "elements",
                offset = 4,
                size = 4,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x8",
                count = 0,
                elementSize = 20,
                is = "ptr",
                name = "definition",
                offset = 8,
                size = 4,
                type = "ptr",
                what = "field"
            }
        },
        is = "struct",
        name = "gameDataInputs",
        offset = 72,
        size = 12,
        type = "struct",
        what = "field"
    },
    {
        address = "0x54",
        fields = {
            {
                address = "0x0",
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
                count = 0,
                elementSize = 72,
                is = "ptr",
                name = "elements",
                offset = 4,
                size = 4,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x8",
                count = 0,
                elementSize = 20,
                is = "ptr",
                name = "definition",
                offset = 8,
                size = 4,
                type = "ptr",
                what = "field"
            }
        },
        is = "struct",
        name = "eventHandlers",
        offset = 84,
        size = 12,
        type = "struct",
        what = "field"
    },
    {
        address = "0x60",
        fields = {
            {
                address = "0x0",
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
                count = 0,
                elementSize = 34,
                is = "ptr",
                name = "elements",
                offset = 4,
                size = 4,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x8",
                count = 0,
                elementSize = 20,
                is = "ptr",
                name = "definition",
                offset = 8,
                size = 4,
                type = "ptr",
                what = "field"
            }
        },
        is = "struct",
        name = "searchAndReplaceFunctions",
        offset = 96,
        size = 12,
        type = "struct",
        what = "field"
    },
    {
        address = "0x6c",
        count = 128,
        elementSize = 1,
        elementType = "char",
        is = "array",
        name = "pad24420",
        offset = 108,
        size = 128,
        type = "array",
        what = "field"
    },
    {
        address = "0xec",
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "tagGroup",
                offset = 0,
                size = 4,
                type = "int",
                what = "field"
            },
            {
                address = "0x4",
                count = 4,
                elementSize = 1,
                elementType = "char",
                is = "ptr",
                name = "path",
                offset = 4,
                size = 4,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x8",
                is = "int",
                name = "pathSize",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0xc",
                is = "union",
                name = "tagHandle",
                offset = 12,
                size = 4,
                type = "union",
                what = "field"
            }
        },
        is = "struct",
        name = "textLabelUnicodeStringsList",
        offset = 236,
        size = 16,
        type = "struct",
        what = "field"
    },
    {
        address = "0xfc",
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "tagGroup",
                offset = 0,
                size = 4,
                type = "int",
                what = "field"
            },
            {
                address = "0x4",
                count = 4,
                elementSize = 1,
                elementType = "char",
                is = "ptr",
                name = "path",
                offset = 4,
                size = 4,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x8",
                is = "int",
                name = "pathSize",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0xc",
                is = "union",
                name = "tagHandle",
                offset = 12,
                size = 4,
                type = "union",
                what = "field"
            }
        },
        is = "struct",
        name = "textFont",
        offset = 252,
        size = 16,
        type = "struct",
        what = "field"
    },
    {
        address = "0x10c",
        fields = {
            {
                address = "0x0",
                is = "float",
                name = "a",
                offset = 0,
                size = 4,
                type = "float",
                what = "field"
            },
            {
                address = "0x4",
                is = "float",
                name = "r",
                offset = 4,
                size = 4,
                type = "float",
                what = "field"
            },
            {
                address = "0x8",
                is = "float",
                name = "g",
                offset = 8,
                size = 4,
                type = "float",
                what = "field"
            },
            {
                address = "0xc",
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
        offset = 268,
        size = 16,
        type = "struct",
        what = "field"
    },
    {
        address = "0x11c",
        is = "int",
        name = "justification",
        offset = 284,
        size = 2,
        type = "short",
        what = "field"
    },
    {
        address = "0x120",
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
        offset = 288,
        size = 4,
        type = "struct",
        what = "field"
    },
    {
        address = "0x124",
        count = 12,
        elementSize = 1,
        elementType = "char",
        is = "array",
        name = "pad24622",
        offset = 292,
        size = 12,
        type = "array",
        what = "field"
    },
    {
        address = "0x130",
        is = "int",
        name = "stringListIndex",
        offset = 304,
        size = 2,
        type = "word",
        unsigned = true,
        what = "field"
    },
    {
        address = "0x132",
        is = "int",
        name = "horizOffset",
        offset = 306,
        size = 2,
        type = "short",
        what = "field"
    },
    {
        address = "0x134",
        is = "int",
        name = "vertOffset",
        offset = 308,
        size = 2,
        type = "short",
        what = "field"
    },
    {
        address = "0x136",
        count = 26,
        elementSize = 1,
        elementType = "char",
        is = "array",
        name = "pad24729",
        offset = 310,
        size = 26,
        type = "array",
        what = "field"
    },
    {
        address = "0x150",
        count = 2,
        elementSize = 1,
        elementType = "char",
        is = "array",
        name = "pad24753",
        offset = 336,
        size = 2,
        type = "array",
        what = "field"
    },
    {
        address = "0x154",
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
        offset = 340,
        size = 4,
        type = "struct",
        what = "field"
    },
    {
        address = "0x158",
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "tagGroup",
                offset = 0,
                size = 4,
                type = "int",
                what = "field"
            },
            {
                address = "0x4",
                count = 4,
                elementSize = 1,
                elementType = "char",
                is = "ptr",
                name = "path",
                offset = 4,
                size = 4,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x8",
                is = "int",
                name = "pathSize",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0xc",
                is = "union",
                name = "tagHandle",
                offset = 12,
                size = 4,
                type = "union",
                what = "field"
            }
        },
        is = "struct",
        name = "listHeaderBitmap",
        offset = 344,
        size = 16,
        type = "struct",
        what = "field"
    },
    {
        address = "0x168",
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "tagGroup",
                offset = 0,
                size = 4,
                type = "int",
                what = "field"
            },
            {
                address = "0x4",
                count = 4,
                elementSize = 1,
                elementType = "char",
                is = "ptr",
                name = "path",
                offset = 4,
                size = 4,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x8",
                is = "int",
                name = "pathSize",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0xc",
                is = "union",
                name = "tagHandle",
                offset = 12,
                size = 4,
                type = "union",
                what = "field"
            }
        },
        is = "struct",
        name = "listFooterBitmap",
        offset = 360,
        size = 16,
        type = "struct",
        what = "field"
    },
    {
        address = "0x178",
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "top",
                offset = 0,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x2",
                is = "int",
                name = "left",
                offset = 2,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x4",
                is = "int",
                name = "bottom",
                offset = 4,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x6",
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
        offset = 376,
        size = 8,
        type = "struct",
        what = "field"
    },
    {
        address = "0x180",
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "top",
                offset = 0,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x2",
                is = "int",
                name = "left",
                offset = 2,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x4",
                is = "int",
                name = "bottom",
                offset = 4,
                size = 2,
                type = "short",
                what = "field"
            },
            {
                address = "0x6",
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
        offset = 384,
        size = 8,
        type = "struct",
        what = "field"
    },
    {
        address = "0x188",
        count = 32,
        elementSize = 1,
        elementType = "char",
        is = "array",
        name = "pad24950",
        offset = 392,
        size = 32,
        type = "array",
        what = "field"
    },
    {
        address = "0x1a8",
        fields = {
            {
                address = "0x0",
                is = "int",
                name = "tagGroup",
                offset = 0,
                size = 4,
                type = "int",
                what = "field"
            },
            {
                address = "0x4",
                count = 4,
                elementSize = 1,
                elementType = "char",
                is = "ptr",
                name = "path",
                offset = 4,
                size = 4,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x8",
                is = "int",
                name = "pathSize",
                offset = 8,
                size = 4,
                type = "dword",
                unsigned = true,
                what = "field"
            },
            {
                address = "0xc",
                is = "union",
                name = "tagHandle",
                offset = 12,
                size = 4,
                type = "union",
                what = "field"
            }
        },
        is = "struct",
        name = "extendedDescriptionWidget",
        offset = 424,
        size = 16,
        type = "struct",
        what = "field"
    },
    {
        address = "0x1b8",
        count = 32,
        elementSize = 1,
        elementType = "char",
        is = "array",
        name = "pad25020",
        offset = 440,
        size = 32,
        type = "array",
        what = "field"
    },
    {
        address = "0x1d8",
        count = 256,
        elementSize = 1,
        elementType = "char",
        is = "array",
        name = "pad25044",
        offset = 472,
        size = 256,
        type = "array",
        what = "field"
    },
    {
        address = "0x2d8",
        fields = {
            {
                address = "0x0",
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
                count = 0,
                elementSize = 80,
                is = "ptr",
                name = "elements",
                offset = 4,
                size = 4,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x8",
                count = 0,
                elementSize = 20,
                is = "ptr",
                name = "definition",
                offset = 8,
                size = 4,
                type = "ptr",
                what = "field"
            }
        },
        is = "struct",
        name = "conditionalWidgets",
        offset = 728,
        size = 12,
        type = "struct",
        what = "field"
    },
    {
        address = "0x2e4",
        count = 128,
        elementSize = 1,
        elementType = "char",
        is = "array",
        name = "pad25198",
        offset = 740,
        size = 128,
        type = "array",
        what = "field"
    },
    {
        address = "0x364",
        count = 128,
        elementSize = 1,
        elementType = "char",
        is = "array",
        name = "pad25223",
        offset = 868,
        size = 128,
        type = "array",
        what = "field"
    },
    {
        address = "0x3e4",
        fields = {
            {
                address = "0x0",
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
                count = 0,
                elementSize = 80,
                is = "ptr",
                name = "elements",
                offset = 4,
                size = 4,
                type = "ptr",
                what = "field"
            },
            {
                address = "0x8",
                count = 0,
                elementSize = 20,
                is = "ptr",
                name = "definition",
                offset = 8,
                size = 4,
                type = "ptr",
                what = "field"
            }
        },
        is = "struct",
        name = "childWidgets",
        offset = 996,
        size = 12,
        type = "struct",
        what = "field"
    }
}
