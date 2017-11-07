local data = {

	backGround = {
		widget="image",
		dim = {100, 100},
		pos = { 0, 0 },
		images = { 
			{
				fileName = "../gui/alpha_sign.png", --../gui/ggMM/main_menu.png  ../gui/alpha_sign_1080.png
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
			mmLogo = {
				widget = "image",
				dim = {80, 30},
				pos = {10, 4},
				images = {
					{
						fileName = "../gui/ebony_spire_logo.png",
					},

				},

			},
			mmVersion = {
				widget = "label",
				dim = {20, 10},
				pos = {89, 94},
				text = "v 1.1.1b",
			},
		},

	},
}

return data
