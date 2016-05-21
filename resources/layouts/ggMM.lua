local data = {

	backGround = {
		widget="image",
		dim = {100, 100},
		pos = { 0, 0 },
		images = { 
			{
				fileName = "", --../gui/ggMM/main_menu.png
			},
		},
		children = {
			mmBackPanel = {
				widget = "image",
				dim = {42, 37},
				pos = {30, 60},
				images = {
					{
						fileName = "../gui/ggMM/bg_ui_option.png",
					},

				},

			},

		},

	},
}

return data
