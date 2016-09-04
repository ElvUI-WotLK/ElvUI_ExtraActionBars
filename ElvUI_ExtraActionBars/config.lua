local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local EAB = E:NewModule('ExtraActionBars','AceEvent-3.0')
local AB = E:GetModule('ActionBars');

-- Defaults
P['actionbar']['bar7'] = {
	['enabled'] = false,
	['mouseover'] = false,
	['buttons'] = 12,
	['buttonsPerRow'] = 12,
	['point'] = 'BOTTOMLEFT',
	['backdrop'] = true,
	['heightMult'] = 1,
	['widthMult'] = 1,
	['buttonsize'] = 30,
	['buttonspacing'] = 4,
	["backdropSpacing"] = 4,
	['alpha'] = 1,
	['inheritGlobalFade'] = false,
	['showGrid'] = true,
	['paging'] = {},
	['visibility'] = '[vehicleui] hide; show',
}

P['actionbar']['bar8'] = {
	['enabled'] = false,
	['mouseover'] = false,
	['buttons'] = 12,
	['buttonsPerRow'] = 12,
	['point'] = 'BOTTOMLEFT',
	['backdrop'] = true,
	['heightMult'] = 1,
	['widthMult'] = 1,
	['buttonsize'] = 30,
	['buttonspacing'] = 4,
	["backdropSpacing"] = 4,
	['alpha'] = 1,
	['inheritGlobalFade'] = false,
	['showGrid'] = true,
	['paging'] = {},
	['visibility'] = '[vehicleui] hide; show',
}

P['actionbar']['bar9'] = {
	['enabled'] = false,
	['mouseover'] = false,
	['buttons'] = 12,
	['buttonsPerRow'] = 12,
	['point'] = 'BOTTOMLEFT',
	['backdrop'] = true,
	['heightMult'] = 1,
	['widthMult'] = 1,
	['buttonsize'] = 30,
	['buttonspacing'] = 4,
	["backdropSpacing"] = 4,
	['alpha'] = 1,
	['inheritGlobalFade'] = false,
	['showGrid'] = true,
	['paging'] = {},
	['visibility'] = '[vehicleui] hide; show',
}

P['actionbar']['bar10'] = {
	['enabled'] = false,
	['mouseover'] = false,
	['buttons'] = 12,
	['buttonsPerRow'] = 12,
	['point'] = 'BOTTOMLEFT',
	['backdrop'] = true,
	['heightMult'] = 1,
	['widthMult'] = 1,
	['buttonsize'] = 30,
	['buttonspacing'] = 4,
	["backdropSpacing"] = 4,
	['alpha'] = 1,
	['inheritGlobalFade'] = false,
	['showGrid'] = true,
	['paging'] = {},
	['visibility'] = '[vehicleui] hide; show',
}

function EAB:InsertOptions()
	if not E.Options.args.blazeplugins then
		E.Options.args.blazeplugins = {
			order = -2,
			type = 'group',
			name = 'Plugins (by Blazeflack)',
			args = {},
		}
	end

	local points = {
		['TOPLEFT'] = 'TOPLEFT',
		['TOPRIGHT'] = 'TOPRIGHT',
		['BOTTOMLEFT'] = 'BOTTOMLEFT',
		['BOTTOMRIGHT'] = 'BOTTOMRIGHT',
	}

	E.Options.args.blazeplugins.args.EAB = {
		order = 40,
		type = 'group',
		name = 'ExtraActionBars',
		disabled = function() return not E.private.actionbar.enable end,
		childGroups = 'tab',
		args = {},
	}

	local group = E.Options.args.blazeplugins.args.EAB.args
	for i = 7, 10 do
		local name = L['Bar ']..i
		group['bar'..i] = {
			order = i,
			name = name,
			type = 'group',
			disabled = function() return not E.private.actionbar.enable end,
			get = function(info) return E.db.actionbar['bar'..i][ info[#info] ] end,
			set = function(info, value) E.db.actionbar['bar'..i][ info[#info] ] = value; AB:PositionAndSizeBar('bar'..i) end,
			args = {
				info = {
					order = 1,
					type = 'header',
					name = name,
				},
				enabled = {
					order = 2,
					type = 'toggle',
					name = L['Enable'],
				},
				restorePosition = {
					order = 3,
					type = 'execute',
					name = L['Restore Bar'],
					desc = L['Restore the actionbars default settings'],
					func = function() E:CopyTable(E.db.actionbar['bar'..i], P.actionbar['bar'..i]); E:ResetMovers('Bar '..i); AB:PositionAndSizeBar('bar'..i) end,
				},
				point = {
					order = 4,
					type = 'select',
					name = L['Anchor Point'],
					desc = L['The first button anchors itself to this point on the bar.'],
					values = points,
				},
				backdrop = {
					order = 5,
					type = 'toggle',
					name = L['Backdrop'],
					desc = L['Toggles the display of the actionbars backdrop.'],
				},
				showGrid = {
					type = 'toggle',
					name = L["Show Empty Buttons"],
					order = 6,
					set = function(info, value) E.db.actionbar['bar'..i][ info[#info] ] = value; AB:UpdateButtonSettingsForBar('bar'..i) end,
				},
				mouseover = {
					order = 7,
					name = L['Mouse Over'],
					desc = L['The frame is not shown unless you mouse over the frame.'],
					type = 'toggle',
				},
				inheritGlobalFade = {
					order = 8,
					type = 'toggle',
					name = L["Inherit Global Fade"],
					desc = L["Inherit the global fade, mousing over, targetting, setting focus, losing health, entering combat will set the remove transparency. Otherwise it will use the transparency level in the general actionbar settings for global fade alpha."],
				},
				buttons = {
					order = 9,
					type = 'range',
					name = L['Buttons'],
					desc = L['The amount of buttons to display.'],
					min = 1, max = NUM_ACTIONBAR_BUTTONS, step = 1,
				},
				buttonsPerRow = {
					order = 10,
					type = 'range',
					name = L['Buttons Per Row'],
					desc = L['The amount of buttons to display per row.'],
					min = 1, max = NUM_ACTIONBAR_BUTTONS, step = 1,
				},
				buttonsize = {
					type = 'range',
					name = L['Button Size'],
					desc = L['The size of the action buttons.'],
					min = 15, max = 60, step = 1,
					order = 11,
					disabled = function() return not E.private.actionbar.enable end,
				},
				buttonspacing = {
					type = 'range',
					name = L['Button Spacing'],
					desc = L['The spacing between buttons.'],
					min = 1, max = 10, step = 1,
					order = 12,
					disabled = function() return not E.private.actionbar.enable end,
				},
				backdropSpacing = {
					type = 'range',
					name = L["Backdrop Spacing"],
					desc = L["The spacing between the backdrop and the buttons."],
					min = 0, max = 10, step = 1,
					order = 13,
					disabled = function() return not E.private.actionbar.enable end,
				},
				heightMult = {
					order = 14,
					type = 'range',
					name = L['Height Multiplier'],
					desc = L['Multiply the backdrops height or width by this value. This is usefull if you wish to have more than one bar behind a backdrop.'],
					min = 1, max = 5, step = 1,
				},
				widthMult = {
					order = 15,
					type = 'range',
					name = L['Width Multiplier'],
					desc = L['Multiply the backdrops height or width by this value. This is usefull if you wish to have more than one bar behind a backdrop.'],
					min = 1, max = 5, step = 1,
				},
				alpha = {
					order = 16,
					type = 'range',
					name = L['Alpha'],
					isPercent = true,
					min = 0, max = 1, step = 0.01,
				},
				paging = {
					type = 'input',
					order = 17,
					name = L['Action Paging'],
					desc = L["This works like a macro, you can run different situations to get the actionbar to page differently.\n Example: '[combat] 2;'"],
					width = 'full',
					multiline = true,
					get = function(info) return E.db.actionbar['bar'..i]['paging'][E.myclass] end,
					set = function(info, value)
						if not E.db.actionbar['bar'..i]['paging'][E.myclass] then
							E.db.actionbar['bar'..i]['paging'][E.myclass] = {}
						end

						E.db.actionbar['bar'..i]['paging'][E.myclass] = value
						AB:UpdateButtonSettings()
					end,
				},
				visibility = {
					type = 'input',
					order = 18,
					name = L['Visibility State'],
					desc = L["This works like a macro, you can run different situations to get the actionbar to show/hide differently.\n Example: '[combat] show;hide'"],
					width = 'full',
					multiline = true,
					set = function(info, value)
						E.db.actionbar['bar'..i]['visibility'] = value;
						AB:UpdateButtonSettings()
					end,
				},
			},
		}
	end
end

E:RegisterModule(EAB:GetName())