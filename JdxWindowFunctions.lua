Windows = {}
DrawWindows = {}

function RegistrationWindow(name, x, y, width, height, title)
      local Data = {
         Name = name,
         WindowKey = -1,
         Type = "Window",
         Title = title,
         Font = JDXConst.WINDOW_TITLE_FONT,
         FontScale = JDXConst.WINDOW_TITLE_FONT_SCALE,
         StartPosX = x,
         StartPosY = y,
         DragPosX = 0,
         DragPosY = 0,
         PosX = 0,
         PosY = 0,
         Width = width,
         Height = height,
         Head = true,
         HeadColor = JDXConst.WINDOW_HEAD_COLOR,
         BodyColor = JDXConst.WINDOW_BACKGROUND_COLOR,
         NotActiveHeadColor = JDXConst.WINDOW_NOT_ACTIVE_HEAD_COLOR,
         TitleColor = JDXConst.WINDOW_TITLE_COLOR,
         Active = false,
         IsMouseRectDrag = false,
         Drag = false,
         RenderTargets = {},
         Children = {}
      }

      function Data:Close()
         for i, render in pairs(self.RenderTargets) do 
            destroyElement(render);
         end
         for i, wnd in pairs(DrawWindows) do 
            if wnd.WindowKey == self.WindowKey then 
               table.remove(DrawWindows, i)
               break;
            end
         end
         for i, element in pairs(self) do 
            self[i] = nil;
         end
      end
      function Data:Draw()
         table.insert(DrawWindows, self);
      end

      local isDraw = false;
      local WKey = -1;
      for key, value in ipairs(Windows) do
         local Name = value.Name;
         local Type = value.Type;
         if Name == Data.Name and Type == Data.Type then 
            isDraw = true;
            WKey = key;
            value.WindowKey = WKey;
         end
      end
      if not isDraw then 
         table.insert(Windows, Data);
         WKey = #Windows;
         Windows[WKey].WindowKey = WKey;
      end

      return Windows[WKey];    
end

function RegistrationLabel(name, x, y, width, height, halign, valign, text, color, scale, font, parent)
    
    local Data = {
        ID = #parent.Children,
        Name = name,
        WindowKey = parent.WindowKey,
        Type = "Label",
        Text = text,
        Font = font,
        FontScale = scale,
        Width = width,
        Height = height,
        HorizontalAlign = halign,
        VerticalAlign = valign,
        StartPosX = x,
        StartPosY = y,
        PosX = 0,
        PosY = 0,
        Color = color,
        ColorCoded = false,
        Children = {}
     };
     local isDraw = false;
     local WKey = -1;
     for key, value in ipairs(parent.Children) do
        local Name = value.Name;
        local Type = value.Type;
        if Name == Data.Name and Type == Data.Type then 
           isDraw = true;
           WKey = key;
        end
     end
     if not isDraw then 
        table.insert(parent.Children, Data);
        WKey = #parent.Children;
     end
     return parent.Children[WKey];
end

function RegistrationButton(name, x, y, width, height, text, parent)
   -- if returnWindow == nil then returnWindow == false end
   local Data = {
      ID = #parent.Children,
      Name = name,
      WindowKey = parent.WindowKey,
      Type = "Button",
      Text = text,
      StartPosX = x,
      StartPosY = y,
      PosX = 0,
      PosY = 0,
      Width = width,
      Height = height,
      Font = JDXConst.BUTTON_TEXT_FONT,
      FontScale = JDXConst.BUTTON_TEXT_FONT_SCALE,
      Color = JDXConst.BUTTON_BACKGROUND_COLOR,
      Foreground = JDXConst.BUTTON_FOREGROUND_COLOR,
      BorderColor = JDXConst.BUTTON_BORDER_COLOR,
      Active = true,
      Input = true,
      IsMouseOverColor = JDXConst.BUTTON_BACKGROUND_MOUSEOVER_COLOR,
      IsMouseOverForegroundColor = JDXConst.BUTTON_FOREGROUND_ACTIVE_COLOR,
      IsPressedColor = JDXConst.BUTTON_BACKGROUND_PRESSED_COLOR,
      IsMouseOver = false,
      IsPressed = false,
      IsLongPressed = false,
      EventHandler = {
            IsMouseOver = function() end,
            IsPressed = function() end,
            IsLongPressed = function() end
      },
      Children = {}
   };
   local isDraw = false;
   local WKey = -1;
   for key, value in ipairs(parent.Children) do
      local Name = value.Name;
      local Type = value.Type;
      if Name == Data.Name and Type == Data.Type then 
         isDraw = true;
         WKey = key;
      end
   end
   if not isDraw then 
      table.insert(parent.Children, Data);
      WKey = #parent.Children;
   end
   return parent.Children[WKey];
end

function RegistrationCheckBox(name, x, y, width, height, parent)
    
   local Data = {
       ID = #parent.Children,
       Name = name,
       WindowKey = parent.WindowKey,
       Type = "CheckBox",
       StartPosX = x,
       StartPosY = y,
       PosX = 0,
       PosY = 0,
       Width = width,
       Height = height,
       Symbol = "",
       Color = JDXConst.CHECKBOX_BACKGROUND_COLOR,
       Foreground = JDXConst.CHECKBOX_FOREGROUND_COLOR,
       BorderColor = JDXConst.CHECKBOX_BORDER_COLOR,
       IsActive = false,
       IsMouseOverColor =  JDXConst.CHECKBOX_BACKGROUND_MOUSEOVER_COLOR,
       IsPressedColor = JDXConst.CHECKBOX_BACKGROUND_PRESSED_COLOR,
       IsMouseOver = false,
       IsPressed = false,
       IsLongPressed = false,
       EventHandler = {
           IsMouseOver = function() end,
           IsPressed = function() end,
           IsLongPressed = function() end
       },
       Children = {}
    };
    local isDraw = false;
    local WKey = -1;
    for key, value in ipairs(parent.Children) do
       local Name = value.Name;
       local Type = value.Type;
       if Name == Data.Name and Type == Data.Type then 
          isDraw = true;
          WKey = key;
       end
    end
    if not isDraw then 
       table.insert(parent.Children, Data);
       WKey = #parent.Children;
    end
    return parent.Children[WKey];
end

function RegistrationTextBox(name, x, y, width, height, parent)
    
   local Data = {
       ID = #parent.Children,
       Name = name,
       WindowKey = parent.WindowKey,
       Type = "TextBox",
       StartPosX = x,
       StartPosY = y,
       PosX = 0,
       PosY = 0,
       Width = width,
       Height = height,
       Font = JDXConst.TEXTBOX_TEXT_FONT,
       FontScale = JDXConst.TEXTBOX_TEXT_FONT_SCALE,
       Color = JDXConst.TEXTBOX_BACKGROUND_COLOR,
       Text = "",
       TextLines = {},
       EndPos = 0,
       EndText = "",
       Input = true,
       ScrollBar = false,
       WordBreak = false,
       WheelPos = 0,
       Redraw = false,
       Foreground = JDXConst.TEXTBOX_FOREGROUND_COLOR,
       IsMouseOverColor = JDXConst.TEXTBOX_BACKGROUND_MOUSEOVER_COLOR,
       IsFocusColor = JDXConst.TEXTBOX_BACKGROUND_FOCUS_COLOR,
       IsMouseOver = false,
       IsFocus = false,
       ScrollBarBackgroundColor = JDXConst.SCROLLBAR_BACKGROUND_COLOR,
       ScrollBarColor = JDXConst.SCROLLBAR_BUTTON_COLOR,
       ScrollBarIsMouseOverColor = JDXConst.SCROLLBAR_BUTTON_MOUSEOVER_COLOR,
       ScrollBarIsPressedColor = JDXConst.SCROLLBAR_BUTTON_PRESSED_COLOR,
       EventHandler = {
           IsMouseOver = function() end,
           IsFocus = function() end,
       },
       Children = {}
    };
    local isDraw = false;
    local WKey = -1;
    for key, value in ipairs(parent.Children) do
       local Name = value.Name;
       local Type = value.Type;
       if Name == Data.Name and Type == Data.Type then 
          isDraw = true;
          WKey = key;
       end
    end
    if not isDraw then 
       table.insert(parent.Children, Data);
       WKey = #parent.Children;
    end
    return parent.Children[WKey];
end

function RegistrationProgressBar(name, x, y, width, height, parent)
    
   local Data = {
       ID = #parent.Children,
       Name = name,
       WindowKey = parent.WindowKey,
       Type = "ProgressBar",
       StartPosX = x,
       StartPosY = y,
       PosX = 0,
       PosY = 0,
       Width = width,
       Height = height,
       Color = JDXConst.PROGRESSBAR_FOREGROUND_COLOR,
       BackgroundColor = JDXConst.PROGRESSBAR_BACKGROUND_COLOR,
       BorderColor = JDXConst.PROGRESSBAR_BORDER_COLOR,
       Value = 0,
       OldValue = 0,
       Children = {}
    };
    local isDraw = false;
    local WKey = -1;
    for key, value in ipairs(parent.Children) do
       local Name = value.Name;
       local Type = value.Type;
       if Name == Data.Name and Type == Data.Type then 
          isDraw = true;
          WKey = key;
       end
    end
    if not isDraw then 
       table.insert(parent.Children, Data);
       WKey = #parent.Children;
    end
    return parent.Children[WKey];
end

function RegistrationListBox(name, x, y, width, height, parent)
      
      local Data = {
         ID = #parent.Children,
         Name = name,
         WindowKey = parent.WindowKey,
         Type = "ListBox",
         StartPosX = x,
         StartPosY = y,
         PosX = 0,
         PosY = 0,
         Width = width,
         Height = height,
         Row = 0,
         WheelPos = 0,
         EndPos = 0,
         ScrollBar = false,
         MultiSelect = false,
         ScrollBarBackgroundColor = JDXConst.SCROLLBAR_BACKGROUND_COLOR,
         ScrollBarColor = JDXConst.SCROLLBAR_BUTTON_COLOR,
         ScrollBarIsMouseOverColor = JDXConst.SCROLLBAR_BUTTON_MOUSEOVER_COLOR,
         ScrollBarIsPressedColor = JDXConst.SCROLLBAR_BUTTON_PRESSED_COLOR,
         DataContext = false,
         IsMouseOver = false,
         EventHandler = {
            IsMouseOver = function() end,
            IsItemMouseOver = function() end,
            IsItemSelected = function() end,
         },
         Step = 1,
         ItemBackgroundColor = JDXConst.LISTBOX_BACKGROUND_COLOR,
         ItemMouseOverColor = JDXConst.LISTBOX_BACKGROUND_MOUSEOVER_COLOR,
         ItemSelectedColor = JDXConst.LISTBOX_BACKGROUND_SELECTED_COLOR,
         ItemsHeight = 30,
         Children = {}
      };

      function Data:AddRow()
         self.Row = self.Row + 1; 
         RegistrationListBoxItem("ListBoxItem_" .. #self.Children, self.Row, self);
      end
      function Data:Clear()
         self.Children = {};
      end
      function Data:AddRange(count)
         for i = 1, count do 
            self:AddRow();
         end
      end
      function Data:SetDataContext(context)
         self.DataContext = true;
         if context == nil then 
            for key, obj in ipairs(self.Children) do
               --context
            end
         end
      end
      function Data:GetSelectedItems()
         local items = {};
         for key, obj in ipairs(self.Children) do
            if obj.IsSelected then 
               table.insert(items, obj);
            end
         end
         return items;
      end

      local isDraw = false;
      local WKey = -1;
      for key, value in ipairs(parent.Children) do
         local Name = value.Name;
         local Type = value.Type;
         if Name == Data.Name and Type == Data.Type then 
            isDraw = true;
            WKey = key;
         end
      end
      if not isDraw then 
         table.insert(parent.Children, Data);
         WKey = #parent.Children;
      end
      return parent.Children[WKey];
end

function RegistrationListBoxItem(name, row, parent)
      
   local Data = {
      ID = #parent.Children,
      Name = name,
      WindowKey = parent.WindowKey,
      Type = "ListBoxItem",
      PosX = 0,
      PosY = 0,
      Width = parent.Width,
      Height = parent.ItemsHeight,
      Step = parent.Step,
      IsDrawn = false,
      Row = row,
      Color = parent.ItemBackgroundColor,
      IsMouseOverColor = parent.ItemMouseOverColor,
      IsSelectedColor = parent.ItemSelectedColor,
      IsMouseOver = false,
      IsSelected = false,
      EventHandler = {
         IsMouseOver = function() end,
         IsSelected = function() end,
      },
      Children = {}
   };
   
   if parent.ScrollBar then 
      Data.Width = Data.Width - 10; 
  end

   local isDraw = false;
   local WKey = -1;
   for key, value in ipairs(parent.Children) do
      local Name = value.Name;
      local Type = value.Type;
      if Name == Data.Name and Type == Data.Type then 
         isDraw = true;
         WKey = key;
      end
   end
   if not isDraw then 
      table.insert(parent.Children, Data);
      WKey = #parent.Children;
   end
   return parent.Children[WKey];
end

function RegistrationRectangle(name, x, y, width, height, color, parent)
    
   local Data = {
       ID = #parent.Children,
       Name = name,
       WindowKey = parent.WindowKey,
       Type = "Rectangle",
       StartPosX = x,
       StartPosY = y,
       PosX = 0,
       PosY = 0,
       Width = width,
       Height = height,
       Color = color,
       Children = {}
    };
    local isDraw = false;
    local WKey = -1;
    for key, value in ipairs(parent.Children) do
       local Name = value.Name;
       local Type = value.Type;
       if Name == Data.Name and Type == Data.Type then 
          isDraw = true;
          WKey = key;
       end
    end
    if not isDraw then 
       table.insert(parent.Children, Data);
       WKey = #parent.Children;
    end
    return parent.Children[WKey];
end