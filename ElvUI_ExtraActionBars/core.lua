local E, L, V, P, G, _ = unpack(ElvUI);
local EAB = E:GetModule("ExtraActionBars");
local AB = E:GetModule("ActionBars");
local EP = LibStub("LibElvUIPlugin-1.0");
local addon, ns = ...;

local split = string.split;

local function CreateBar(id)
	local bar = CreateFrame("Frame", "ElvUI_Bar"..id, E.UIParent, "SecureHandlerBaseTemplate, SecureHandlerShowHideTemplate");
	local point, anchor, attachTo, x, y = split(",", AB["barDefaults"]["bar"..id].position);
	bar:Point(point, anchor, attachTo, x, y);
	bar.id = id;
	bar:CreateBackdrop("Default");
	bar:SetFrameStrata("LOW");

	local offset = E.Spacing;
	bar.backdrop:SetPoint("TOPLEFT", bar, "TOPLEFT", offset, -offset);
	bar.backdrop:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", -offset, offset);

	bar.buttons = {};
	bar.bindButtons = AB["barDefaults"]["bar"..id].bindButtons;
	AB:HookScript(bar, "OnEnter", "Bar_OnEnter");
	AB:HookScript(bar, "OnLeave", "Bar_OnLeave");

	for i = 1, 12 do
		bar.buttons[i] = CreateFrame("CheckButton", format(bar:GetName().."Button%d", i), bar, "AlternateButtonTemplate");
		AB:StyleButton(bar.buttons[i]);

		bar.buttons[i]:SetAttribute("saveentries", "ExtraBar_ButtonEntries");
		bar.buttons[i]:SetAttribute("savesettings", "ExtraBar_ButtonSettings");

		AB:HookScript(bar.buttons[i], "OnEnter", "Button_OnEnter");
		AB:HookScript(bar.buttons[i], "OnLeave", "Button_OnLeave");
	end

	bar:Execute([[ebButtons = newtable(); owner:GetChildList(ebButtons);]]);
	bar:SetAttribute("_onstate-page", [[ 
		for i, button in ipairs(buttons) do
			button:SetAttribute("actionpage", tonumber(newstate));
		end
	]]);
	bar:SetAttribute("_onstate-show", [[
		if(newstate == "hide") then
			self:Hide();
		else
			self:Show();
		end
	]]);

	AB["handledBars"]["bar"..id] = bar;
	E:CreateMover(bar, "ElvAB_"..id, L["Bar "]..id, nil, nil, nil,"ALL,ACTIONBARS");
	AB:PositionAndSizeBar("bar"..id);
	return bar;
end

function EAB:UpdateButtonSettings()
	for i = 7, 10 do
		AB:PositionAndSizeBar("bar"..i);
	end
end

function EAB:CreateBars()
	AB["barDefaults"]["bar7"] = {
		["page"] = 7,
		["bindButtons"] = "EXTRABAR7BUTTON",
		["conditions"] = "",
		["position"] = "BOTTOM,ElvUI_Bar1,TOP,0,82"
	};
	AB["barDefaults"]["bar8"] = {
		["page"] = 8,
		["bindButtons"] = "EXTRABAR8BUTTON",
		["conditions"] = "",
		["position"] = "BOTTOM,ElvUI_Bar1,TOP,0,122"
	};
	AB["barDefaults"]["bar9"] = {
		["page"] = 9,
		["bindButtons"] = "EXTRABAR9BUTTON",
		["conditions"] = "",
		["position"] = "BOTTOM,ElvUI_Bar1,TOP,0,162"
	};
	AB["barDefaults"]["bar10"] = {
		["page"] = 10,
		["bindButtons"] = "EXTRABAR10BUTTON",
		["conditions"] = "",
		["position"] = "BOTTOM,ElvUI_Bar1,TOP,0,202"
	};

	for i = 7, 10 do
		CreateBar(i);
	end

	for b, _ in pairs(AB["handledbuttons"]) do
		AB:RegisterButton(b, true);
	end

	if(not ExtraBar_ButtonEntries) then
		ExtraBar_ButtonEntries = {};
		ExtraBar_ButtonSettings = {};
	end
	ExtraBar_ButtonEntries, ExtraBar_ButtonSettings = ABTMethods_UpdateSavedDataVersion(ExtraBar_ButtonEntries, ExtraBar_ButtonSettings);
	ABTMethods_LoadAll(ExtraBar_ButtonEntries, ExtraBar_ButtonSettings);
end

function EAB:PLAYER_REGEN_ENABLED()
	self:UnregisterEvent("PLAYER_REGEN_ENABLED");

	EAB:CreateBars();
end

function EAB:PLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD");

	if(InCombatLockdown()) then self:RegisterEvent("PLAYER_REGEN_ENABLED"); return; end

	EAB:CreateBars();
end

function EAB:OnInitialize()
	EP:RegisterPlugin(addon, EAB.InsertOptions);

	if(E.private.actionbar.enable ~= true) then return; end

	self:RegisterEvent("PLAYER_ENTERING_WORLD");
end