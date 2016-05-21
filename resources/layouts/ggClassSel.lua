local data = {

	backGround = {
		widget="image",
		dim = {100, 100},
		pos = { 0, 0 },
		images = { 
			{
				fileName = "",--../gui/ggClassSelection/ggClassSel.png
			},
		},
		children = {
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