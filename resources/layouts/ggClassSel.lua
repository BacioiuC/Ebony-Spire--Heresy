local data = {

	backGround = {
		widget="image",
		dim = {100, 100},
		pos = { 0, 0 },
		images = { 
			{
				fileName = "../gui/alpha_sign.png",--../gui/ggClassSelection/ggClassSel.png ./gui/alpha_sign.png
			},
		},
		children = {
			--[[charName = {
				widget = "edit box",
				dim = {21, 22},
				pos = {29, 10},
				text = "Hero",
			},--]]
			classPanel = {
				widget = "image",
				dim = {21, 22},
				pos = {11, 61},
				images = {
					{
						fileName = "../gui/ggMM/bg_ui_option.png",
					},

				},

			},

			classDescription = {
				widget = "image",
				dim = {52, 46},
				pos = {35, 49},
				images = {
					{
						fileName = "../gui/ggMM/bg_ui_option.png",
					},

				},

			}, -- end of class description

		},

	},
}

return data