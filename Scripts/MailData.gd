extends Node

#	1 : [0-"Subject", 1-"Content", 2-"Sender", 3-IsEmailAvailable, 4-IsEmailDeleted, 5-HasBeenRead, 6-[0-TaskName, 1-IsTaskCompleted, 2-Quota, 3-AssociatedApp], 7-Type],
var LoadedEmails = {
	1 : [
	"Congratulations!",
	"Welcome to the company. I have some good news, you have been promoted! You are now one of my Elite™ Employees! Anyway get back to work! Now!\nPS: I'll be sending you tasks to do.", 
	"Boss",
	false,
	false,
	false,
	null,
	"Message"
	],
	
	2 : [
	"Task #1",
	"Your first task is simple, even a simple flat brained monkey like yourself can do it! First open the Team Manager app, then choose which employees you will be firing. You have until your computer battery reaches 0%, if you don't finish the task in this time, I won't pay you. You will see a progress counter on the bottom right of your taskbar once you start the task.",
	"Boss",
	false,
	false,
	false,
	["Fire", false, 5, "TeamManager"],
	"Task"
	],
	3 : [
	"Task #2",
	"I need you to draw a new company mascot. We have found ourselves in a bit of hot water recently, with all the layoffs and all. A mascot is exactly what we need! I would recommend that you use PainterPro, this app can be found and installed via the Crow App Store on the taskbar. Once you have drawn the mascot, export the drawing and send me the file.",
	"Boss",
	false,
	false,
	false,
	["Draw", false, 1, null],
	"Task"
	],
	4 : [
	"Task #3",
	"It turns out, we ended up needing those ten employees that your fired earlier. So we will have to hire some replacements. Again, open the team manager app, beware of your battery, and get cracking!",
	"Boss",
	false,
	false,
	false,
	["Hire", false, 5, "TeamManager"],
	"Task",
	],
	5 : [
	"The End?",
	"Welp, you've reached the end of the game - for now. You have reached the end of coded tasks, but this doesn't have to be the end. From here on out, you can continue to use CrowOS, but as an open world game. So go out and explore the software!\n\nPS: Thank you very much for playing my game! (:\n-Daniel Lott",
	"Developer",
	false,
	false,
	false,
	null,
	"Message"
	]
}
