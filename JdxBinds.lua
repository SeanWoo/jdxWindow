local function ShowCursor()
    if isCursorShowing() then
        showCursor(false);
    else
        showCursor(true);
    end
end

local IsActiveLMouseDown = false;
local IsActiveLMousePressed = false;
local IsActiveKeyDown = false;
local IsActiveLShiftDown = false;
local IsActiveMouseWheelUp = false;
local IsActiveMouseWheelDown = false;
local IsActiveLAltDown = false;
local Language = "en";
local ActiveButton = "";

function IsLMouseDown()
    if IsActiveLMouseDown then 
        IsActiveLMouseDown = false;
        return true;
    end
    return false;
end

function IsLMousePressed()
    return IsActiveLMousePressed;
end

function IsKeyDown()
    if ActiveButton ~= "" then 
        local result = ActiveButton;
        ActiveButton = "";
        return result;
    end
    return "";
end

function IsMouseWheelUp()
    if IsActiveMouseWheelUp then 
        IsActiveMouseWheelUp = false;
        return true;
    end
    return false;
end
function IsMouseWheelDown()
    if IsActiveMouseWheelDown then 
        IsActiveMouseWheelDown = false;
        return true;
    end
    return false;
end

local function BindKeys()
    bindKey("x", "down", ShowCursor);
    bindKey("mouse1", "down", function() 
        IsActiveLMouseDown = true;
        IsActiveLMousePressed = true; 
    end);
    bindKey("mouse1", "up", function() 
        IsActiveLMouseDown = false;
        IsActiveLMousePressed = false;
    end);
    bindKey("lshift", "down", function() 
        IsActiveLShiftDown = true;
    end);
    bindKey("lshift", "up", function() 
        IsActiveLShiftDown = false;
    end);
    bindKey("lalt", "down", function() 
        IsActiveLAltDown = true;
    end);
    bindKey("lalt", "up", function() 
        IsActiveLAltDown = false;
    end);
    bindKey("mouse_wheel_up", "down", function() 
        IsActiveMouseWheelUp = true;
    end);
    bindKey("mouse_wheel_down", "down", function() 
        IsActiveMouseWheelDown = true;
    end);
    bindKey("mouse_wheel_up", "up", function() 
        IsActiveMouseWheelUp = false;
    end);
    bindKey("mouse_wheel_down", "up", function() 
        IsActiveMouseWheelDown = false;
    end);
end

function IsChangeLanguage()
    return 
end

function onClientKey(button, press) 
    local ru = {
        ["q"] = "й",
        ["w"] = "ц",
        ["e"] = "у",
        ["r"] = "к",
        ["t"] = "е",
        ["y"] = "н",
        ["u"] = "г",
        ["i"] = "ш",
        ["o"] = "щ",
        ["p"] = "з",
        ["["] = "х",
        ["]"] = "ъ",
        ["a"] = "ф",
        ["s"] = "ы",
        ["d"] = "в",
        ["f"] = "а",
        ["g"] = "п",
        ["h"] = "р",
        ["j"] = "о",
        ["k"] = "л",
        ["l"] = "д",
        [";"] = "ж",
        ["\'"] = "э",
        ["z"] = "я",
        ["x"] = "ч",
        ["c"] = "с",
        ["v"] = "м",
        ["b"] = "и",
        ["n"] = "т",
        ["m"] = "ь",
        [","] = "б",
        ["."] = "ю",
        ["/"] = ".",
        ["?"] = ","
    }
 

    IsActiveKeyDown = not IsActiveKeyDown;
    if IsActiveLShiftDown and IsActiveLAltDown then 
        if Language == "en" then 
            Language = "ru";
        else 
            Language = "en";
        end
    end
    if IsActiveKeyDown then 
        if #button == 1 or button == "backspace" or button == "space" then
            if button == "space" then 
                ActiveButton = " ";
                return;
            end
            if IsActiveLShiftDown then 
                button = string.upper(button);
                local buttons = {
                    ["-"] = "_",
                    ["="] = "+",
                    ["1"] = "!",
                    ["2"] = "@",
                    ["3"] = "#",
                    ["4"] = "$",
                    ["5"] = "%",
                    ["6"] = "^",
                    ["7"] = "&",
                    ["8"] = "*",
                    ["9"] = "(",
                    ["0"] = ")",
                    ["/"] = "?"
                }
                if buttons[button] then button = buttons[button] end

            end
            if Language == "ru" and button ~= "backspace" then 
                button = ru[button];
            end
            ActiveButton = button;
            return;
        end
    else 
        ActiveButton = "";
    end
end

addEventHandler("onClientResourceStart", root, BindKeys);
addEventHandler("onClientKey", root, onClientKey)