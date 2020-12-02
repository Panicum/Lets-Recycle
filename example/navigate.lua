local M = {}

M.CONTROLLER = "main:/controller"

function M.startmenu()
	msg.post(M.CONTROLLER, "show_startmenu")
end

function M.choose_mode()
	msg.post(M.CONTROLLER, "choose_mode")
end

function M.game()
	msg.post(M.CONTROLLER, "show_game")
end

function M.play_again()
	msg.post(M.CONTROLLER, "play_again")
end

function M.login(message)
	msg.post(M.CONTROLLER, "show_login", { text = message })
end

function M.register()
	print("NAV SHOW REG")
	msg.post(M.CONTROLLER, "show_register")
end

function M.help()
	msg.post(M.CONTROLLER, "show_help")
end

function M.credits()
	msg.post(M.CONTROLLER, "show_credits")
end

function M.leaderboard()
	msg.post(M.CONTROLLER, "show_leaderboard")
end

function M.show_popup(text)
	msg.post(M.CONTROLLER, "show_popup", { text = text })
end

function M.hide_popup()
	msg.post(M.CONTROLLER, "hide_popup")
end

function M.show_spinner()
	msg.post("main:/spinner#spinner", "show")
end

function M.hide_spinner()
	msg.post("main:/spinner#spinner", "hide")
end

return M