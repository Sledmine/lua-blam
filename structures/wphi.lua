local weaponHudInterfaceStructure = {
    childHud = {type = "dword", offset = 0xC},
    -- //TODO Check if this property should be moved to a nested property type
    usingParentHudFlashingParameters = {
        type = "bit",
        offset = "word",
        bitLevel = 1
    },
    -- padding1 = {type = "word", offset = 0x12},
    totalAmmoCutOff = {
        type = "word",
        offset = 0x14
    },
    loadedAmmoCutOff = {
        type = "word",
        offset = 0x16
    },
    heatCutOff = {type = "word", offset = 0x18},
    ageCutOff = {type = "word", offset = 0x1A},
    -- padding2 = {size = 0x20, offset = 0x1C},
    -- screenAlignment = {type = "word", },
    -- padding3 = {size = 0x2, offset = 0x3E},
    -- padding4 = {size = 0x20, offset = 0x40},
    crosshairs = {
        type = "table",
        offset = 0x88,
        jump = 0x68,
        rows = {
            type = {type = "word", offset = 0x0},
            mapType = {
                type = "word",
                offset = 0x2
            },
            -- padding1 = {size = 0x2, offset = 0x4},
            -- padding2 = {size = 0x1C, offset = 0x6},
            bitmap = {
                type = "dword",
                offset = 0x30
            },
            overlays = {
                type = "table",
                offset = 0x38,
                jump = 0x6C,
                rows = {
                    widthScale = {
                        type = "float",
                        offset = 0x4
                    },
                    heightScale = {
                        type = "float",
                        offset = 0x8
                    },
                    -- //TODO This should be split into 2 properties
                    --[[anchorOffset = {
                        type = "table",
                        offset = 0x0,
                        jump = 0,
                        rows = {
                            x = {
                                type = "word",
                                offset = 0x0
                            },
                            y = {
                                type = "word",
                                offset = 0x2
                            }
                        }
                    },]]
                    --[[scalingFlags = {
                        type = "table",
                        offset = 0xC,
                        jump = 0,
                        rows = {
                            dontScaleOffset = {
                                type = "bit",
                                offset = 0x0,
                                bitLevel = 0
                            },
                            dontScaleSize = {
                                type = "bit",
                                offset = 0x0,
                                bitLevel = 1
                            },
                            useHighResScale = {
                                type = "bit",
                                offset = 0x0,
                                bitLevel = 2
                            }
                            -- padding1 = {type = "bit", offset = 0x0, bitLevel = 4}
                        }
                    },]]
                    -- padding1 = {size = 0x2, offset = 0xE},
                    -- padding2 = {size = 0x14, offset = 0x10},
                    defaultColor = {
                        type = "table",
                        offset = 0x0,
                        jump = 0,
                        rows = {
                            a = {
                                type = "byte",
                                offset = 0x24
                            },
                            r = {
                                type = "byte",
                                offset = 0x25
                            },
                            g = {
                                type = "byte",
                                offset = 0x26
                            },
                            b = {
                                type = "byte",
                                offset = 0x27
                            }
                        }
                    },
                    --[[
                            flashingColor = {
                        type = "pointer",
                        pointerType = "table",
                        offset = 0x28,
                        jump = 0,
                        rows = {
                            a = {type = "float", offset = 0x0},
                            r = {type = "float", offset = 0x4},
                            g = {type = "float", offset = 0x8},
                            b = {type = "float", offset = 0xC}
                        }
                    },
                    
                    flashPeriod = {type = "float", offset = 0x2C},
                    flashDelay = {type = "float", offset = 0x30},
                    numberOfFlashes = {type = "word", offset = 0x34},
                    flashFlags = {
                        type = "table",
                        offset = 0x36,
                        jump = 0,
                        rows = {
                            reverseDefault = {type = "bit", offset = 0x0, bitLevel = 0}
                        }
                    },
                    flashLength = {type = "float", offset = 0x38},
                    --[[
                    disabledColor = {
                        type = "pointer",
                        pointerType = "table",
                        offset = 0x3C,
                        jump = 0,
                        rows = {
                            a = {type = "float", offset = 0x0},
                            r = {type = "float", offset = 0x4},
                            g = {type = "float", offset = 0x8},
                            b = {type = "float", offset = 0xC}
                        }
                    },
                    -- //FIXME This offsets are WRONG!
                    --padding3 = {size = 0x4, offset = 0x40},]]
                    --frameRate = {type = "word", offset = 0x44},
                    --sequenceIndex = {type = "word", offset = 0x48},
                    sequenceIndex = {type = "byte", offset = 0x46}
                    --[[flags = {
                        type = "table",
                        offset = 0x48,
                        jump = 0,
                        rows = {
                            flashesWhenActive = {type = "bit", offset = 0x0, bitLevel = 0},
                            notASprite = {type = "bit", offset = 0x0, bitLevel = 1},
                            showOnlyWhenZoomed = {type = "bit", offset = 0x0, bitLevel = 2},
                            showSniperData = {type = "bit", offset = 0x0, bitLevel = 3},
                            hideAreaOutsideReticle = {type = "bit", offset = 0x0, bitLevel = 4},
                            oneZoomLevel = {type = "bit", offset = 0x0, bitLevel = 5},
                            dontShowWhenZoomed = {type = "bit", offset = 0x0, bitLevel = 6}
                        }
                    }]],
                    --padding4 = {size = 0x20, offset = 0x4C}
                }
            }
            -- padding3 = {size = 0x28, offset = 0x40}
        }
    }

    --[[
    crosshairs = {type = "word", offset = 0x84},
    defaultBlue = {type = "byte", offset = 0x208},
    defaultGreen = {type = "byte", offset = 0x209},
    defaultRed = {type = "byte", offset = 0x20A},
    defaultAlpha = {type = "byte", offset = 0x20B},
    sequenceIndex = {
        type = "short",
        offset = 0x22A
    }
    ]]
}
