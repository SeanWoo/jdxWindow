local isRestore = false;

function DrawWindow(W)
    --Move Window
    if isCursorShowing() then
        local screenWidth, screenHeight = guiGetScreenSize();
        local cPosX, cPosY = getCursorPosition();
        local cursorPosX = cPosX * screenWidth;
        local cursorPosY = cPosY * screenHeight;
        if W.Head and cursorPosX >= W.StartPosX + W.DragPosX and cursorPosX <= W.StartPosX + W.DragPosX + W.Width and cursorPosY >= W.StartPosY + W.DragPosY and cursorPosY <= W.StartPosY + W.DragPosY + JDXConst.WINDOW_HEAD_HEIGHT then
            W.IsMouseRectDrag = true;
            if IsLMousePressed() and W.Active then 
                W.Drag = true;
            else 
                W.Drag = false;
            end
        else 
            W.IsMouseRectDrag = false;
        end

        --TODO: Переделать алгоритм перемещения окна
        if W.Drag then 
            W.DragPosX = cursorPosX - W.StartPosX - W.Width/2;
            W.DragPosY = cursorPosY - W.StartPosY - JDXConst.WINDOW_HEAD_HEIGHT/2;
        end
        
        if cursorPosX >= W.StartPosX + W.DragPosX and cursorPosX <= W.StartPosX + W.DragPosX + W.Width and cursorPosY >= W.StartPosY + W.DragPosY and cursorPosY <= W.StartPosY + W.DragPosY + W.Height + JDXConst.WINDOW_HEAD_HEIGHT then
            if W.Active == false and IsLMouseDown() then 
                W.Active = true;
                local WKey = -1;
                for key, value in ipairs(Windows) do 
                    if value.Name ~= W.Name then 
                        value.Active = false;
                    else 
                        WKey = key
                    end
                end
                --[[
                    ЛОГИКА ДЛЯ ПЕРЕЩЕНИЯ ОКОН НА ПРОРИСОВКЕ
                ]]
            end
        end
        
    end
    local headcolor = W.HeadColor;
    if not W.Active then 
        headcolor = W.NotActiveHeadColor;
    else
        headcolor = W.HeadColor;
    end

    W.PosX = W.StartPosX + W.DragPosX;
    W.PosY = W.StartPosY + W.DragPosY;

    --Draw Window
    local textSizes = getTextSizes(W.Title, W.FontScale, W.Font);
    if W.Head then
        dxDrawRectangle(
            W.PosX, 
            W.PosY, 
            W.Width, 
            JDXConst.WINDOW_HEAD_HEIGHT, 
            headcolor 
        ); --Head
        dxDrawText(
            W.Title, 
            W.PosX + (W.Width/2) - (textSizes.width/2), 
            W.PosY + (JDXConst.WINDOW_HEAD_HEIGHT/2)-(textSizes.height/2), 
            0, 
            0, 
            JDXConst.WINDOW_TITLE_COLOR, 
            JDXConst.WINDOW_TITLE_FONT_SCALE, 
            JDXConst.WINDOW_TITLE_FONT
        ); --Title
    end
    dxDrawRectangle(
        W.PosX, 
        W.PosY + JDXConst.WINDOW_HEAD_HEIGHT, 
        W.Width, 
        W.Height, 
        W.
        BodyColor 
    ); --Body
    --return W;
end

function DrawButton(Button, parent, active)
    local backgroundColorButton = Button.Color;
    local foregroundColorButton = Button.Foreground;
    if parent.Active or parent.Active == nil or active then 
        Button.PosX = parent.PosX + Button.StartPosX;
        if parent.Active == nil then 
            Button.PosY = parent.PosY + Button.StartPosY;
        else 
            Button.PosY = parent.PosY + Button.StartPosY + JDXConst.WINDOW_HEAD_HEIGHT;
        end
    else
        Button.PosX = Button.StartPosX;
        if parent.Active == nil then 
            Button.PosY = Button.StartPosY;
        else 
            Button.PosY = Button.StartPosY + JDXConst.WINDOW_HEAD_HEIGHT;
        end
    end


   --Click
   if isCursorShowing() and Windows[parent.WindowKey].Active then
      local screenWidth, screenHeight = guiGetScreenSize();
      local cPosX, cPosY = getCursorPosition();
      local cursorPosX = cPosX * screenWidth;
      local cursorPosY = cPosY * screenHeight;
      if cursorPosX >= Button.PosX and cursorPosX <= Button.PosX + Button.Width and cursorPosY >= Button.PosY and cursorPosY <= Button.PosY + Button.Height then
         Button.IsMouseOver = true;
         Button.EventHandler.IsMouseOver();
         if IsLMouseDown() then 
            Button.IsPressed = true;
            Button.EventHandler.IsPressed(Button);
         else
            Button.IsPressed = false;
         end
         if IsLMousePressed() then 
            Button.IsLongPressed = true;
            Button.EventHandler.IsLongPressed(Button);
         else 
            Button.IsLongPressed = false;
         end
      else
         Button.IsMouseOver = false;
         Button.IsPressed = false;
         Button.IsLongPressed = false;
      end
   end

   if Button.IsMouseOver then backgroundColorButton = Button.IsMouseOverColor; foregroundColorButton = Button.IsMouseOverForegroundColor; end
   if Button.IsLongPressed then backgroundColorButton = Button.IsPressedColor; end

    if Windows[Button.WindowKey].RenderTargets[Button.Name] == nil then
        if Windows[Button.WindowKey].RenderTargets[Button.Name] ~= nil then 
            destroyElement(Windows[Button.WindowKey].RenderTargets[Button.Name]);
        end
        local renderTarget = dxCreateRenderTarget(Button.Width, Button.Height, true);
        dxSetRenderTarget(renderTarget);
        
        dxDrawLine(0, 0, Button.Width, 0, Button.BorderColor);
        dxDrawLine(Button.Width-1, 0, Button.Width-1, Button.Height-1, Button.BorderColor);
        dxDrawLine(0, 0, 0, Button.Height-1, Button.BorderColor);
        dxDrawLine(0, Button.Height-1, Button.Width, Button.Height-1, Button.BorderColor);

        dxSetRenderTarget();
        Windows[Button.WindowKey].RenderTargets[Button.Name] = renderTarget;
    end 
    local textSizes = getTextSizes(Button.Text, Button.FontScale, Button.Font);
    dxDrawRectangle(
       Button.PosX, 
       Button.PosY, 
       Button.Width, 
       Button.Height, 
       backgroundColorButton 
    ); --Body 
    dxDrawText(
       Button.Text, 
       Button.PosX + Button.Width/2 - textSizes.width/2, 
       Button.PosY + (Button.Height/2)-(textSizes.height/2), 
       0, 
       0, 
       foregroundColorButton, 
       Button.FontScale, 
       Button.Font
    ); --Text
    dxDrawImage(Button.PosX, Button.PosY, Button.Width, Button.Height, Windows[Button.WindowKey].RenderTargets[Button.Name]);

end

function DrawLabel(Label, parent, active)
    if parent.Active or parent.Active == nil or active then 
        Label.PosX = parent.PosX + Label.StartPosX;
        if parent.Active == nil then 
            Label.PosY = parent.PosY + Label.StartPosY;
        else 
            Label.PosY = parent.PosY + Label.StartPosY + JDXConst.WINDOW_HEAD_HEIGHT;
        end
        if Label.HorizontalAlign == "right" then 
            Label.PosX = Label.PosX + Label.Width - getTextSizes(Label.Text, Label.FontScale, Label.Font).width;
        end
        if Label.VerticalAlign == "bottom" then 
            Label.PosY = Label.PosY + Label.Height - getTextSizes(Label.Text, Label.FontScale, Label.Font).height;
        end
        if Label.HorizontalAlign == "center" then 
            Label.PosX = Label.PosX + (Label.Width/2) - (getTextSizes(Label.Text, Label.FontScale, Label.Font).width/2);
        end
        if Label.VerticalAlign == "center" then 
            Label.PosY = Label.PosY + (Label.Height/2) - (getTextSizes(Label.Text, Label.FontScale, Label.Font).height/2);
        end
    else 
        Label.PosX = Label.StartPosX;
        if parent.Active == nil then 
            Label.PosY = Label.StartPosY;
        else 
            Label.PosY = Label.StartPosY + JDXConst.WINDOW_HEAD_HEIGHT;
        end
        if Label.HorizontalAlign == "right" then 
            Label.PosX = Label.PosX + Label.Width - getTextSizes(Label.Text, Label.FontScale, Label.Font).width;
        end
        if Label.VerticalAlign == "bottom" then 
            Label.PosY = Label.PosY + Label.Height - getTextSizes(Label.Text, Label.FontScale, Label.Font).height;
        end
        if Label.HorizontalAlign == "center" then 
            Label.PosX = Label.PosX + (Label.Width/2) - (getTextSizes(Label.Text, Label.FontScale, Label.Font).width/2);
        end
        if Label.VerticalAlign == "center" then 
            Label.PosY = Label.PosY + (Label.Height/2) - (getTextSizes(Label.Text, Label.FontScale, Label.Font).height/2);
        end
    end


    dxDrawText(
       Label.Text, 
       Label.PosX, 
       Label.PosY,       
       nil, 
       nil, 
       Label.Color, 
       Label.FontScale, 
       Label.Font,
       "left",
       "top",
       false,
       false,
       false,
       Label.ColorCoded
    );
end

function DrawCheckBox(CheckBox, parent, active)
    local colorCheckBox = CheckBox.Color;
    if parent.Active or parent.Active == nil or active then 
        CheckBox.PosX = parent.PosX + CheckBox.StartPosX;
        if parent.Active == nil then 
            CheckBox.PosY = parent.PosY + CheckBox.StartPosY;
        else 
            CheckBox.PosY = parent.PosY + CheckBox.StartPosY + JDXConst.WINDOW_HEAD_HEIGHT;
        end
    else 
        CheckBox.PosX = CheckBox.StartPosX;
        if parent.Active == nil then 
            CheckBox.PosY = CheckBox.StartPosY;
        else 
            CheckBox.PosY = CheckBox.StartPosY + JDXConst.WINDOW_HEAD_HEIGHT;
        end
    end

        --Click
    if isCursorShowing() and Windows[parent.WindowKey].Active then
        local screenWidth, screenHeight = guiGetScreenSize();
        local cPosX, cPosY = getCursorPosition();
        local cursorPosX = cPosX * screenWidth;
        local cursorPosY = cPosY * screenHeight;
        if cursorPosX >= CheckBox.PosX and cursorPosX <= CheckBox.PosX + CheckBox.Width and cursorPosY >= CheckBox.PosY and cursorPosY <= CheckBox.PosY + CheckBox.Height then
            CheckBox.IsMouseOver = true;
            CheckBox.EventHandler.IsMouseOver();
            if IsLMouseDown() then 
                CheckBox.IsPressed = true;
                CheckBox.IsActive = not CheckBox.IsActive;
                CheckBox.EventHandler.IsPressed(CheckBox);
            else
                CheckBox.IsPressed = false;
            end
            if IsLMousePressed() then 
                CheckBox.IsLongPressed = true;
                CheckBox.EventHandler.IsLongPressed(CheckBox);
            else 
                CheckBox.IsLongPressed = false;
            end
        else
            CheckBox.IsMouseOver = false;
            CheckBox.IsPressed = false;
            CheckBox.IsLongPressed = false;
        end
    end

    if CheckBox.IsMouseOver then colorCheckBox = CheckBox.IsMouseOverColor; end
    if CheckBox.IsLongPressed then colorCheckBox = CheckBox.IsPressedColor; end

    if CheckBox.IsActive then 
        CheckBox.Symbol = "✔";
    else 
        CheckBox.Symbol = "";
    end 

    if Windows[CheckBox.WindowKey].RenderTargets[CheckBox.Name] == nil then
        if Windows[CheckBox.WindowKey].RenderTargets[CheckBox.Name] ~= nil then 
            destroyElement(Windows[CheckBox.WindowKey].RenderTargets[CheckBox.Name]);
        end
        local renderTarget = dxCreateRenderTarget(CheckBox.Width, CheckBox.Height, true);
        dxSetRenderTarget(renderTarget);
        
        dxDrawLine(0, 0, CheckBox.Width, 0, CheckBox.BorderColor);
        dxDrawLine(CheckBox.Width-1, 0, CheckBox.Width-1, CheckBox.Height-1, CheckBox.BorderColor);
        dxDrawLine(0, 0, 0, CheckBox.Height-1, CheckBox.BorderColor);
        dxDrawLine(0, CheckBox.Height-1, CheckBox.Width, CheckBox.Height-1, CheckBox.BorderColor);

        dxSetRenderTarget();
        Windows[CheckBox.WindowKey].RenderTargets[CheckBox.Name] = renderTarget;
    end 

    local textSizes = getTextSizes(CheckBox.Symbol, 1, "default-bold");
    dxDrawRectangle(
        CheckBox.PosX, 
        CheckBox.PosY, 
        CheckBox.Width, 
        CheckBox.Height, 
        colorCheckBox 
    ); --Body 
    dxDrawText(
        CheckBox.Symbol, 
        CheckBox.PosX + CheckBox.Width/2 - textSizes.width/2, 
        CheckBox.PosY + (CheckBox.Height/2)-(textSizes.height/2), 
       0, 
       0, 
       CheckBox.Foreground, 
       1, 
       "default-bold"
    ); --Text

    dxDrawImage(CheckBox.PosX, CheckBox.PosY, CheckBox.Width, CheckBox.Height, Windows[CheckBox.WindowKey].RenderTargets[CheckBox.Name]);

end

function DrawTextBox(TextBox, parent, active)
    local objectChanged = false;
    local colorTextBox = TextBox.Color;

    if parent.Active or parent.Active == nil or active then 
        TextBox.PosX = parent.PosX + TextBox.StartPosX;
        if parent.Active == nil then 
            TextBox.PosY = parent.PosY + TextBox.StartPosY;
        else 
            TextBox.PosY = parent.PosY + TextBox.StartPosY + JDXConst.WINDOW_HEAD_HEIGHT;
        end
    else 
        TextBox.PosX = TextBox.StartPosX;
        if parent.Active == nil then 
            TextBox.PosY = TextBox.StartPosY;
        else 
            TextBox.PosY = TextBox.StartPosY + JDXConst.WINDOW_HEAD_HEIGHT;
        end
    end
    local step = getTextSizes(TextBox.Text, TextBox.FontScale, TextBox.Font).height;
    TextBox.EndPos = ((step*#TextBox.TextLines)-TextBox.Height)+40;
        --Click
    if isCursorShowing() and Windows[parent.WindowKey].Active then
        local screenWidth, screenHeight = guiGetScreenSize();
        local cPosX, cPosY = getCursorPosition();
        local cursorPosX = cPosX * screenWidth;
        local cursorPosY = cPosY * screenHeight;
        if cursorPosX >= parent.PosX + TextBox.StartPosX and cursorPosX <= parent.PosX + TextBox.StartPosX + TextBox.Width and cursorPosY >= parent.PosY + JDXConst.WINDOW_HEAD_HEIGHT + TextBox.StartPosY and cursorPosY <= parent.PosY + JDXConst.WINDOW_HEAD_HEIGHT + TextBox.StartPosY + TextBox.Height then
            TextBox.IsMouseOver = true;
            TextBox.EventHandler.IsMouseOver(TextBox);
            if IsLMouseDown() then 
                TextBox.IsFocus = true;
                TextBox.EventHandler.IsFocus(TextBox);
            end
            if IsMouseWheelUp() then 
                if TextBox.WheelPos < 0 then 
                    TextBox.WheelPos = TextBox.WheelPos + step;
                    TextBox.Redraw = true;
                else 
                    TextBox.WheelPos = 0;
                end
            end
            if IsMouseWheelDown() then 
                if TextBox.WheelPos >= -TextBox.EndPos then 
                    TextBox.WheelPos = TextBox.WheelPos - step;
                    TextBox.Redraw = true;
                end
            end
            objectChanged = true;
        else
            TextBox.IsMouseOver = false;
            TextBox.IsFocus = false;
        end
    end

    if TextBox.IsMouseOver then colorTextBox = TextBox.IsMouseOverColor; end
    if TextBox.IsFocus then colorTextBox = TextBox.IsFocusColor; end

    if TextBox.IsFocus and TextBox.Input then 
        local button = IsKeyDown();
        if button ~= "" and button ~= nil then
            if button ~= "backspace" then
                TextBox.Text = TextBox.Text .. button;
                TextBox.Redraw = true;
            end
            if button == "backspace" then
                TextBox.Text = string.sub(TextBox.Text, 0, #TextBox.Text-1);
                TextBox.Redraw = true;
            end
        end
    end

    dxDrawRectangle(
        TextBox.PosX, 
        TextBox.PosY, 
        TextBox.Width, 
        TextBox.Height, 
        colorTextBox
    ); --Body 

    if Windows[TextBox.WindowKey].RenderTargets[TextBox.Name] == nil or TextBox.Redraw then
        if Windows[TextBox.WindowKey].RenderTargets[TextBox.Name] ~= nil then 
            destroyElement(Windows[TextBox.WindowKey].RenderTargets[TextBox.Name]);
        end
        local renderTarget = dxCreateRenderTarget(TextBox.Width, TextBox.Height, true);
        dxSetRenderTarget(renderTarget);
        local textSizes = getTextSizes(TextBox.Text, TextBox.FontScale, TextBox.Font);
        if TextBox.WordBreak then 
            local lines = {};
            if textSizes.width > TextBox.Width-20 then 
                
                local words = split(TextBox.Text, " ")
                local line = 1
                local word = 1
             
                while (words[word]) do
                   repeat
                   if words[word]~="/br" then
                      lines[line] = (lines[line] and (lines[line] .. " ") or "") .. words[word]
                      word = word + 1
                   else
                      lines[line] = (lines[line] and (lines[line] .. "") or "") .. ""
                      word = word + 1
                   end
                   until (words[word]=="/br" or (not words[word]) or dxGetTextWidth(lines[line] .. " " .. words[word], TextBox.FontScale, TextBox.Font, true) >= TextBox.Width-10) 
                   line = line + 1
                end
            else 
                table.insert(lines, TextBox.Text);
            end
            for i, text in pairs(lines) do
                if text ~= TextBox.TextLines[i] then 
                    TextBox.TextLines[i] = text;
                end

                if 
                (TextBox.PosY + TextBox.WheelPos + (textSizes.height*(i-1)) + 5) > TextBox.PosY and 
                (TextBox.PosY + TextBox.WheelPos + (textSizes.height*(i-1)) + 5) < TextBox.PosY + TextBox.Height - 10
                then
                    dxDrawText(
                        text, 
                        10, 
                        TextBox.WheelPos + (textSizes.height*(i-1)) + 5, 
                        0, 
                        0, 
                        TextBox.Foreground, 
                        1, 
                        "default-bold",
                        "left",
                        "top",
                        false,
                        false,
                        false,
                        true
                    ); --Text
                    TextBox.EndText = text;
                end
            end
        else
            dxDrawText(
                TextBox.Text, 
                10, 
                (TextBox.Height/2) - (textSizes.height/2), 
                0, 
                0, 
                TextBox.Foreground, 
                TextBox.FontScale, 
                TextBox.Font,
                "left",
                "top",
                false,
                false,
                false,
                true
            ); --Text
        end 
        dxSetRenderTarget();
        Windows[TextBox.WindowKey].RenderTargets[TextBox.Name] = renderTarget;
        TextBox.Redraw = false;
    end 
    dxDrawImage(TextBox.PosX, TextBox.PosY, TextBox.Width, TextBox.Height, Windows[TextBox.WindowKey].RenderTargets[TextBox.Name]);
    
    if TextBox.ScrollBar and step*#TextBox.TextLines > TextBox.Height then
        DrawScrollBar(TextBox);
    end
end

function DrawProgressBar(ProgressBar, parent, active)

    if parent.Active or parent.Active == nil or active then 
        ProgressBar.PosX = parent.PosX + ProgressBar.StartPosX;
        if parent.Active == nil then 
            ProgressBar.PosY = parent.PosY + ProgressBar.StartPosY;
        else 
            ProgressBar.PosY = parent.PosY + ProgressBar.StartPosY + JDXConst.WINDOW_HEAD_HEIGHT;
        end
    else 
        ProgressBar.PosX = 0 + ProgressBar.StartPosX;
        if parent.Active == nil then 
            ProgressBar.PosY = ProgressBar.StartPosY;
        else 
            ProgressBar.PosY = ProgressBar.StartPosY + JDXConst.WINDOW_HEAD_HEIGHT;
        end
    end

    if Windows[ProgressBar.WindowKey].RenderTargets[ProgressBar.Name] == nil or ProgressBar.OldValue ~= ProgressBar.Value then
        if Windows[ProgressBar.WindowKey].RenderTargets[ProgressBar.Name] ~= nil then 
            destroyElement(Windows[ProgressBar.WindowKey].RenderTargets[ProgressBar.Name]);
        end
        local value = ((ProgressBar.Value/100) * ProgressBar.Width)-2;
        if value < 0 then value = 0 end
        local renderTarget = dxCreateRenderTarget(ProgressBar.Width, ProgressBar.Height, true);
        dxSetRenderTarget(renderTarget);
        dxDrawRectangle(
            0, 
            0, 
            ProgressBar.Width, 
            ProgressBar.Height, 
            ProgressBar.BackgroundColor
        );
        dxDrawRectangle(
            1, 
            1, 
            value, 
            ProgressBar.Height-2, 
            ProgressBar.Color
        ); --Body 

        dxDrawLine(0, 0, ProgressBar.Width, 0, ProgressBar.BorderColor);
        dxDrawLine(ProgressBar.Width-1, 0, ProgressBar.Width-1, ProgressBar.Height-1, ProgressBar.BorderColor);
        dxDrawLine(0, 0, 0, ProgressBar.Height-1, ProgressBar.BorderColor);
        dxDrawLine(0, ProgressBar.Height-1, ProgressBar.Width, ProgressBar.Height-1, ProgressBar.BorderColor);


        dxSetRenderTarget();
        Windows[ProgressBar.WindowKey].RenderTargets[ProgressBar.Name] = renderTarget;
        ProgressBar.OldValue = ProgressBar.Value;
    end 
    dxDrawImage(ProgressBar.PosX, ProgressBar.PosY, ProgressBar.Width, ProgressBar.Height, Windows[ProgressBar.WindowKey].RenderTargets[ProgressBar.Name]);
end

function DrawListBox(ListBox, parent, active)

    if parent.Active or parent.Active == nil or active then 
        ListBox.PosX = parent.PosX + ListBox.StartPosX;
        if parent.Active == nil then 
            ListBox.PosY = parent.PosY + ListBox.StartPosY;
        else 
            ListBox.PosY = parent.PosY + ListBox.StartPosY + JDXConst.WINDOW_HEAD_HEIGHT;
        end
    else 
        ListBox.PosX = ListBox.StartPosX;
        if parent.Active == nil then 
            ListBox.PosY = ListBox.StartPosY;
        else 
            ListBox.PosY = ListBox.StartPosY + JDXConst.WINDOW_HEAD_HEIGHT;
        end
    end

    local step = ListBox.ItemsHeight;
    ListBox.EndPos = ((step*#ListBox.Children)-ListBox.Height)+(ListBox.Step*#ListBox.Children);
    --Click
    if isCursorShowing() and Windows[parent.WindowKey].Active then
        local screenWidth, screenHeight = guiGetScreenSize();
        local cPosX, cPosY = getCursorPosition();
        local cursorPosX = cPosX * screenWidth;
        local cursorPosY = cPosY * screenHeight;
        if cursorPosX >= ListBox.PosX and cursorPosX <= ListBox.PosX + ListBox.Width and cursorPosY >= ListBox.PosY and cursorPosY <= ListBox.PosY + ListBox.Height then
            ListBox.IsMouseOver = true;
            ListBox.EventHandler.IsMouseOver(ListBox);
            if #ListBox.Children > 0 then 
                step = ListBox.Children[1].Height + ListBox.Children[1].Step;
            end
            if IsMouseWheelUp() then 
                if #ListBox.Children > 0 then 
                    if ListBox.WheelPos < 0 then 
                        ListBox.WheelPos = ListBox.WheelPos + step;
                    end
                end 
            end
            if IsMouseWheelDown() then 
                if #ListBox.Children > 0 then 
                    if ListBox.WheelPos > -ListBox.EndPos then 
                        ListBox.WheelPos = ListBox.WheelPos - step;
                    end
                end 
            end
        else
            ListBox.IsMouseOver = false;
         end
    end

    if ListBox.ScrollBar then
        DrawScrollBar(ListBox);
    end
end

function DrawListBoxItem(ListBoxItem, parent, active)
    local colorItem = ListBoxItem.Color;
    ListBoxItem.PosX = parent.PosX;
    ListBoxItem.PosY = parent.PosY + ((ListBoxItem.Height + ListBoxItem.Step) * (ListBoxItem.Row-1)) + parent.WheelPos;

    
    --Click
    if isCursorShowing() and Windows[parent.WindowKey].Active and ListBoxItem.IsDrawn then
        local screenWidth, screenHeight = guiGetScreenSize();
        local cPosX, cPosY = getCursorPosition();
        local cursorPosX = cPosX * screenWidth;
        local cursorPosY = cPosY * screenHeight;
        if cursorPosX >= ListBoxItem.PosX and cursorPosX <= ListBoxItem.PosX + ListBoxItem.Width and cursorPosY >= ListBoxItem.PosY and cursorPosY <= ListBoxItem.PosY + ListBoxItem.Height then
            ListBoxItem.IsMouseOver = true;
            ListBoxItem.EventHandler.IsMouseOver(ListBoxItem);
            parent.EventHandler.IsItemMouseOver(ListBoxItem);
            if IsLMouseDown() then 
                if parent.MultiSelect then
                    ListBoxItem.IsSelected = not ListBoxItem.IsSelected;
                else 
                    for i, k in pairs(parent.Children) do 
                        if k.Name ~= ListBoxItem.Name then
                            k.IsSelected = false;
                        else 
                            ListBoxItem.IsSelected = not ListBoxItem.IsSelected;
                        end
                    end
                end
                ListBoxItem.EventHandler.IsSelected(ListBoxItem);
                parent.EventHandler.IsItemSelected(ListBoxItem);
            end
        else
            ListBoxItem.IsMouseOver = false;
         end
    end
    
    if ListBoxItem.IsMouseOver then colorItem = ListBoxItem.IsMouseOverColor; end
    if ListBoxItem.IsSelected then colorItem = ListBoxItem.IsSelectedColor; end

    if ListBoxItem.PosY >= parent.PosY and ListBoxItem.PosY + ListBoxItem.Height <= parent.PosY + parent.Height then 
        dxDrawRectangle(
            ListBoxItem.PosX + 1, 
            ListBoxItem.PosY + 1, 
            ListBoxItem.Width - 2, 
            ListBoxItem.Height, 
            colorItem
        ); --Body 
        ListBoxItem.IsDrawn = true;
    else 
        ListBoxItem.IsDrawn = false;
    end
end

function DrawRectangle(Rectangle, parent, active)
    if parent.Active or parent.Active == nil or active then 
        Rectangle.PosX = parent.PosX + Rectangle.StartPosX;
        if parent.Active == nil then 
            Rectangle.PosY = parent.PosY + Rectangle.StartPosY;
        else 
            Rectangle.PosY = parent.PosY + Rectangle.StartPosY + JDXConst.WINDOW_HEAD_HEIGHT;
        end
    else 
        Rectangle.PosX = Rectangle.StartPosX;
        if parent.Active == nil then 
            Rectangle.PosY = Rectangle.StartPosY;
        else 
            Rectangle.PosY = Rectangle.StartPosY + JDXConst.WINDOW_HEAD_HEIGHT;
        end
    end

    dxDrawRectangle(
        Rectangle.PosX,
        Rectangle.PosY,
        Rectangle.Width,
        Rectangle.Height,
        Rectangle.Color
    );
end

local MainButtDown = false;
function DrawScrollBar(Object)
    local MainButtPosX = Object.PosX + Object.Width - 9;
    local MainButtPosY = Object.PosY - (((Object.WheelPos * (Object.Height-41)) / Object.EndPos))+1;
    local MainButtIsMouseOver = false;
    local MainButtColor = Object.ScrollBarColor;
    local DragPosY = 0;

    --Click
    if isCursorShowing() and Windows[Object.WindowKey].Active then
        local screenWidth, screenHeight = guiGetScreenSize();
        local cPosX, cPosY = getCursorPosition();
        local cursorPosX = cPosX * screenWidth;
        local cursorPosY = cPosY * screenHeight;
        if cursorPosX >= MainButtPosX and cursorPosX <= MainButtPosX + 10 and cursorPosY >= MainButtPosY and cursorPosY <= MainButtPosY + 40 then
            MainButtIsMouseOver = true;
            if IsLMousePressed() then 
                MainButtDown = true;
                Object.Redraw = true;
            else
                MainButtDown = fals
            end
        else
            if not IsLMousePressed() then 
                MainButtDown = false;
            end
            MainButtIsMouseOver = false;
        end
        if MainButtDown then
            Object.WheelPos = Object.WheelPos + -(cursorPosY - MainButtPosY) + 20;
            Object.Redraw = true;
        end
        if Object.WheelPos > 0 then 
            Object.WheelPos = 0;
            Object.Redraw = true;
        end
        if Object.WheelPos < -Object.EndPos then 
            Object.WheelPos = -Object.EndPos;
            Object.Redraw = true;
        end
    end

    if MainButtIsMouseOver then MainButtColor = Object.ScrollBarIsMouseOverColor end
    if MainButtDown then MainButtColor = Object.ScrollBarIsPressedColor end

    dxDrawRectangle(
        Object.PosX + Object.Width - 10,
        Object.PosY,
        10,
        Object.Height,
        Object.ScrollBarBackgroundColor
    );--Background
    dxDrawRectangle(
        MainButtPosX,
        MainButtPosY,
        8,
        40,
        MainButtColor
    );--Button
end

local RenderTargetWindows = {}
function DrawObjects()
    if isRestore then 
        for key, window in pairs(DrawWindows) do 
            for k, render in pairs(window.RenderTargets) do 
                destroyElement(render);
                --render = nil;
            end
            window.RenderTargets = {};
        end
        for key, render in pairs(RenderTargetWindows) do 
            outputChatBox(key)
            destroyElement(render);
            --render = nil;
        end
        RenderTargetWindows = {};
    end
    --Activation windows and remove
    if #DrawWindows > 0 then
        for key, window in ipairs(DrawWindows) do 
            if window.Active then 
                table.remove(DrawWindows, key);
                table.insert(DrawWindows, window);
            end
            if Windows[window.WindowKey] == nil then
                table.remove(DrawWindows, key);
            end
        end
        
        --Draw Windows
        for key, window in ipairs(DrawWindows) do
            local function DrawChildren(objects, parent, active)
                
                for key, value in ipairs(objects) do 
                    
                    if value.Type == "Button" then 
                        DrawButton(value, parent, active);
                    elseif value.Type == "Label" then
                        DrawLabel(value, parent, active);
                    elseif value.Type == "CheckBox" then
                        DrawCheckBox(value, parent, active);
                    elseif value.Type == "TextBox" then
                        DrawTextBox(value, parent, active);
                    elseif value.Type == "ProgressBar" then 
                        DrawProgressBar(value, parent, active);
                    elseif value.Type == "ListBox" then 
                        DrawListBox(value, parent, active);
                    elseif value.Type == "ListBoxItem" then 
                        DrawListBoxItem(value, parent, active);
                    elseif value.Type == "Rectangle" then 
                        DrawRectangle(value, parent, active);
                    end
                    
                    if #value.Children ~= 0 then 
                        if value.Type ~= "ListBoxItem" then
                            DrawChildren(value.Children, value, false);
                        else 
                            if value.IsDrawn then
                                DrawChildren(value.Children, value, false);
                            end
                        end
                    end
                end
            end
            if window.Active then 
                DrawWindow(window);
                DrawChildren(window.Children, window, false);
                if RenderTargetWindows[window.Name] ~= nil then 
                    destroyElement(RenderTargetWindows[window.Name]);
                    RenderTargetWindows[window.Name] = nil; --Remove RenderTarget
                end
            else 
                if RenderTargetWindows[window.Name] == nil then
                    DrawWindow(window); 
                    DrawChildren(window.Children, window, true);
                    outputDebugString("[JDX][RT] Create RT window: [" .. window.Name .. "]", 3)
                    local rt = dxCreateRenderTarget(window.Width, window.Height + JDXConst.WINDOW_HEAD_HEIGHT*2, true);
                    dxSetRenderTarget(rt);
                    DrawChildren(window.Children, window);
                    dxSetRenderTarget();
                    RenderTargetWindows[window.Name] = rt;
                    rt = nil;
                end
                DrawWindow(window);
                dxDrawImage(window.StartPosX + window.DragPosX, window.StartPosY + window.DragPosY, window.Width, window.Height + JDXConst.WINDOW_HEAD_HEIGHT*2, RenderTargetWindows[window.Name], 0, 0, 0, tocolor(255,255,255,170))
            end
            if isRestore then 
                DrawWindow(window); 
                DrawChildren(window.Children, window, true);
                isRestore = false;
            end
        end
    end
end

local function Restore(didClearRenderTargets)
    if didClearRenderTargets then
        isRestore = true;
        DrawObjects();
    end
end

addEventHandler("onClientRestore",root, Restore);
addEventHandler("onClientRender", root, DrawObjects);