extends Node

#	1 : [0-"Subject", 1-"Content", 2-"Sender", 3-IsEmailAvailable, 4-IsEmailDeleted, 5-HasBeenRead, 6-[0-TaskName, 1-IsTaskCompleted, 2-Quota, 3-AssociatedApp, 4-TaskTime], 7-Type, 8-AttachedMoneyAmount],
var LoadedEmails = {
	1 : [
	"Congratulations!",
	"Welcome to the company. I have some good news, you have been promoted! You are now one of my Elite™ Employees! Anyway get back to work! Now!\nPS: I'll be sending you tasks to do.", 
	"Boss",
	false,
	false,
	false,
	null,
	"Message",
	null
	],
	
	2 : [
	"Task #1",
	"Your first task is simple, even a simple flat brained monkey like yourself can do it! First open the Team Manager app, then choose which employees you will be firing. You have until your computer battery reaches 0%, if you don't finish the task in this time, BAD BAD things will happen. You will see a progress counter on the bottom right of your taskbar once you start the task. REMEMBER to return to this email and submit the task when you are finished!",
	"Boss",
	false,
	false,
	false,
	["Fire", false, 5, "TeamManager", 120],
	"Task",
	null
	],
	
	3 : [
	"Paycheck #1",
	"You have recieved a payment of $10 for completing a task!",
	"Boss",
	false,
	false,
	false,
	null,
	"Paycheck",
	10
	],
	
	4 : [
	"Task #2",
	"I need you to draw a new company mascot. We have found ourselves in a bit of hot water recently, with all the layoffs and all. A mascot is exactly what we need! I would recommend that you use PainterPro, this app can be found and installed via the Crow App Store on the taskbar. Once you have drawn the mascot, export the drawing and send me the file.",
	"Boss",
	false,
	false,
	false,
	["Draw", false, 1, null, 60*5],
	"Task",
	null
	],
	
	5 : [
	"Paycheck #2",
	"You have recieved a payment of $20 for completing a task!",
	"Boss",
	false,
	false,
	false,
	null,
	"Paycheck",
	20
	],
	
	6 : [
	"Task #3",
	"It turns out, we ended up needing those ten employees that your fired earlier. So we will have to hire some replacements. Again, open the team manager app, beware of your battery, and get cracking!",
	"Boss",
	false,
	false,
	false,
	["Hire", false, 5, "TeamManager", 60*1.5],
	"Task",
	null,
	],
	
	7 : [
	"Paycheck #3",
	"You have recieved a payment of $30 for completing a task!",
	"Boss",
	false,
	false,
	false,
	null,
	"Paycheck",
	30
	],
	
	8 : [
	"Task #4",
	"I need you to hack TurboNews, they have recently released an article condeming the company's treatment of our employees. I need you to hack their website and steal their files, we must gain intel on their next article before it is released. To hack a website, open the terminal app and use the command '/hack'.",
	"Boss",
	false,
	false,
	false,
	["Hack", false, 12, null, 60*2],
	"Task",
	null
	],
	
	9 : [
	"Paycheck #4",
	"You have recieved a payment of $40 for completing a task!",
	"Boss",
	false,
	false,
	false,
	null,
	"Paycheck",
	40
	],
	
	10 : [
	"Task #5",
	"I need you to create a list of ways we can improve the company, make sure to make the document look nice. You can create a document using the Writer App in the taskbar. Once you have finished the document you can send it to me via email.",
	"Boss",
	false,
	false,
	false,
	["Write", false, 1, null, 60*3],
	"Task",
	null
	],
	
	11 : [
	"Paycheck #5",
	"You have recieved a payment of $50 for completing a task!",
	"Boss",
	false,
	false,
	false,
	null,
	"Paycheck",
	50
	],
	
	12 : [
	"The End?",
	"Welp, you've reached the end of the game - for now. You have reached the end of coded tasks, but this doesn't have to be the end. From here on out, you can continue to use CrowOS, but as an open world game. So go out and explore the software!\n\nPS: Thank you very much for playing my game! (:\n-Daniel Lott",
	"Developer",
	false,
	false,
	false,
	null,
	"Message",
	null
	]
}
