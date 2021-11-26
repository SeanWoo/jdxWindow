function getTextSizes(text, scale, font)
    local table = {
        width = dxGetTextWidth(text, scale, font, false), 
        height = dxGetFontHeight(scale, font)
    }
    return table;
end
