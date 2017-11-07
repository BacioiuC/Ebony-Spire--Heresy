local data = {
	scanlineBg = {
		widget="image",
		dim = {100, 100},
		pos = { 0, 0 },
		images = { 
			{
				fileName = "../gui/alpha_sign.png",
			},
		},
		children = {
			backGround = {
				widget="image",
				dim = {40, 40},
				pos = {30, 55 },
				images = { 
					{
						fileName = "../gui/ggMM/bg_ui_option.png", --
					},
				},
				children = {
					scroll2Info = {
						widget = "label",
						dim = {100, 10},
						pos = {4, 35},
						text = "== Press <c:9FC43A>ESC</c> to return ==",
					},


				},

			},
		},
	},
}

return data