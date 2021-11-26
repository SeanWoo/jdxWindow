function jdxCreateWindow(ID, x, y, width, height, title)
   local W = RegistrationWindow(ID, x, y, width, height, title);
   return W;
end

function jdxCreateButton(name, x, y, width, height, text, parent)
   local Button = RegistrationButton(name, x, y, width, height, text, parent);
   return Button;
end

function jdxCreateLabel(name, x, y, width, height, halign, valign, text, color, scale, font, parent)
   local Label = RegistrationLabel(name, x, y, width, height, halign, valign, text, color, scale, font, parent);
   return Label;
end

function jdxCreateCheckBox(name, x, y, width, height, parent)
   local CheckBox = RegistrationCheckBox(name, x, y, width, height, parent)
   return CheckBox;
end

function jdxCreateTextBox(name, x, y, width, height, parent)
   local TextBox = RegistrationTextBox(name, x, y, width, height, parent)
   return TextBox;
end

function jdxCreateProgressBar(name, x, y, width, height, parent)
   local ProgressBar = RegistrationProgressBar(name, x, y, width, height, parent)
   return ProgressBar;
end

function jdxCreateListBox(name, x, y, width, height, parent)
   local GridBox = RegistrationListBox(name, x, y, width, height, parent)
   return GridBox;
end

function jdxCreateRectangle(name, x, y, width, height, color, parent)
   local Rectangle = RegistrationRectangle(name, x, y, width, height, color, parent);
   return Rectangle;
end

function NewDesign(name, x)
   local sX, sY = guiGetScreenSize();
   local wnd = jdxCreateWindow(name, (sX/2-250/2)+x, (sY/2-550/2) , 250, 550, "New Design");

   local bt = jdxCreateButton("Design_Butt", 10, 10, 230, 50, "Button", wnd);
   bt.EventHandler.IsPressed = function() 
      
   end
   jdxCreateCheckBox("Design_CheckBox", 10, 80, 20, 20, wnd);
   local checkbox = jdxCreateCheckBox("Design_CheckBox2", 40, 80, 20, 20, wnd);
   checkbox.IsActive = true;
   local list = jdxCreateListBox("Design_List", 10, 110, 230, 200, wnd);
   list.ScrollBar = true;
   local players = {
      "Amarant_Nightshade",
      "Sean_Baker",
      "John_Hernandez",
      "Kendall_Brooks",
      "Malisha_Ogarro",
      "Frank_Bilz",
      "Henry_Tomassino",
      "Arron_Locos",
      "Alivarus_Morgulius",
      "Franc_Dirl"
   }
   for i, k in ipairs(players) do 
      list:AddRow();
      local lab = jdxCreateLabel("c231_label" .. i, 5, 10, 1, 1, "left", "top", "#FF0000ID: " .. i .. "   #FFFFFF" .. players[i], tocolor(255,255,0), 0.8, "default-bold", list.Children[i]);
      lab.ColorCoded = true;
      jdxCreateButton("bbb" .. i, list.Width - 95, 7, 60, 20, "В БАН", list.Children[i]);
   end

   local ProgressBar = jdxCreateProgressBar("Design_Progressbar", 10, 330, 230, 15, wnd);
   ProgressBar.Value = 50;

   local textBox = jdxCreateTextBox("textBox_1", 10, 350, 230, 100, wnd);
   textBox.ScrollBar = true;
   textBox.Text = "0.0008";
   textBox.WordBreak = true;
   local l = jdxCreateLabel("Design_Label", 0, 470, 250, 30, "center", "center", "Денис индюк", tocolor(200, 200, 255, 255), 1.5, "defaul-bold", wnd);

   local cnt = 0;
   setTimer ( 
      function() 
         if wnd.WindowKey ~= nil then
            cnt = cnt + 1;
            if cnt == 101 then 
               cnt = 0;
            end
            ProgressBar.Value = cnt; 
         end
      end, 
      100, 
      0);


   local CloseButton = jdxCreateButton("CloseButton", 10, 510, 230, 30, "Закрыть", wnd);
   CloseButton.BorderColor = tocolor(200, 0, 0, 255);
   CloseButton.IsMouseOverColor = tocolor(200, 20, 20, 180);
   CloseButton.IsPressedColor = tocolor(200, 40, 40, 200);
   CloseButton.Foreground = tocolor(200, 0, 0, 255);
   CloseButton.EventHandler.IsPressed = function() wnd:Close() end;

   wnd:Draw();
end


function main()
   bindKey("b", "down", function() 
      setClipboard(toJSON(Windows));
   end)
   NewDesign("a", 0)
end

addEventHandler("onClientResourceStart", root, main);


addCommandHandler("tplocal", function() 
   local lp = getLocalPlayer();
   setElementPosition(lp, 2485.00000, -1667.00000, 13.34375)
end)
addEventHandler("onClientPlayerSpawn", getLocalPlayer(), function() 
   local lp = getLocalPlayer();
   setElementPosition(lp, 2485.00000, -1667.00000, 13.34375) 
end)
addCommandHandler("ow", NewDesign)
