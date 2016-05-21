local data = {
	bgFull = {
		widget = "image",
		dim = {100, 100},
		pos = {0, -100},
		images = {
			{

				fileName = "../gui/action_phase/bg.png"
			},

		}, -- end of images		
		children = {
			csBgPanel = {


				widget = "image",
				dim = { 40, 25 },
				pos = { 30, 37 },
				images = {
					{

						fileName = "../gui/action_phase/background.png"
					},

				}, -- end of images
				children = {
					lbText = {
						widget = "label",
						dim = { 45, 2},
						pos = { 1, 3},
						text = "Quit Battle?"
					},

					confirmButton = {
						widget = "button",
						dim = { 14, 8},
						pos = { 4, 14 },
						text = "OK",
						images = {
							normal = {
								{
									fileName = "../gui/action_phase/end_turn_button.png",
									color = {1, 1, 1, 1},
								},
							},
							pushed = {
								{
									fileName = "../gui/action_phase/end_turn_button_hover_pressed.png",
								},
							},	
							hover = {
								{
									fileName = "../gui/action_phase/end_turn_button_hover_pressed.png",
								},
							},
						},
					},

					cancelButton = {
						widget = "button",
						dim = { 14, 8},
						pos = { 22, 14 },
						text = "Cancel",
						images = {
							normal = {
								{
									fileName = "../gui/action_phase/end_turn_button.png",
									color = {1, 1, 1, 1},
								},
							},
							pushed = {
								{
									fileName = "../gui/action_phase/end_turn_button_hover_pressed.png",
								},
							},	
							hover = {
								{
									fileName = "../gui/action_phase/end_turn_button_hover_pressed.png",
								},
							},
						},
					},			

				},
			}, -- end of cs bg panel
		}, -- end of csBgPanel children
	},
}

return data