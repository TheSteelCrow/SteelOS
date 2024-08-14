extends Panel

var Quotes = [

"Hawaii has always been a very pivotal role in the Pacific. It is in the Pacific. It is a part of the United States that is an island that is right here.
(Dan Quayle during a visit to Hawaii in 1989)",

"I was recently on a tour of Latin America, and the only regret I have was that I didn't study Latin harder in school so I could converse with those people.
(J. Danforth Quayle)",

"If we don't succeed, we run the risk of failure.
(J. Danforth Quayle)",

"Welcome to President Bush, Mrs. Bush, and my fellow astronauts.
(Vice President Dan Quayle)",

"Mars is essentially in the same orbit... Mars is somewhat the same distance from the Sun, which is very important. We have seen pictures where there are canals, we believe, and water. If there is water, that means there is oxygen. If oxygen, that means we can breathe.
(Vice President Dan Quayle, 8/11/89)",

"What a waste it is to lose one's mind. Or not to have a mind is being very wasteful. How true that is.
(Vice President Dan Quayle)",

"The Holocaust was an obscene period in our nation's history. I mean in this century's history. But we all lived in this century. I didn't live in this century.
(Vice President Dan Quayle, 9/15/88)",

"I believe we are on an irreversible trend toward more freedom and democracy - but that could change.
(Vice President Dan Quayle, 5/22/89)",

"One word sums up probably the responsibility of any vice president, and that one word is 'to be prepared'.
(Vice President Dan Quayle, 12/6/89)",

"May our nation continue to be the beakon of hope to the world.
(The Quayles' 1989 Christmas card) [Not a beacon of literacy]",

"Verbosity leads to unclear, inarticulate things.
(Vice President Dan Quayle)",

"We don't want to go back to tomorrow, we want to go forward.
(Vice President Dan Quayle)",

"I have made good judgements in the Past. I have made good judgements in the Future.
(Vice President Dan Quayle)",

"The future will be better tomorrow.
(Vice President Dan Quayle)",

"We're going to have the best-educated American people in the world.
(Vice President Dan Quayle, 9/21/88)",

"People that are really very weird can get into sensitive positions and have a tremendous impact on history.
(Vice President Dan Quayle)",

"I stand by all the misstatements that I've made.
(Vice President Dan Quayle to Sam Donaldson, 1/17/89)",

"We have a firm commitment to NATO, we are a *part* of NATO. We have a firm commitment to Europe. We are a *part* of Europe.
(Vice President Dan Quayle)",

"Public speaking is very easy.
(Vice President Dan Quayle to reporters in 10/88)",

"I am not part of the problem. I am a Republican.
(Vice President Dan Quayle)",

"I love California, I practically grew up in Phoenix.
(Vice President Dan Quayle)",

"A low voter turnout is an indication of fewer people going to the polls.
(Vice President Dan Quayle)",

"When I have been asked during these last weeks who caused the riots and the killing in L.A., my answer has been direct and simple: Who is to blame for the riots? The rioters are to blame. Who is to blame for the killings? The killers are to blame.
(Vice President Dan Quayle)",

"Illegitimacy is something we should talk about in terms of not having it.
(Vice President Dan Quayle, 5/20/92, reported in Esquire, 8/92)",

"We are ready for any unforeseen event that may or may not occur.
(Vice President Dan Quayle, 9/22/90)",

"For NASA, space is still a high priority.
(Vice President Dan Quayle, 9/5/90)",

"Quite frankly, teachers are the only profession that teach our children.
(Vice President Dan Quayle, 9/18/90)",

"The American people would not want to know of any misquotes that Dan Quayle may or may not make.
(Vice President Dan Quayle)",

"We're all capable of mistakes, but I do not care to enlighten you on the mistakes we may or may not have made.
(Vice President Dan Quayle)",

"It isn't pollution that's harming the environment. It's the impurities in our air and water that are doing it.
(Vice President Dan Quayle)",

"[It's] time for the human race to enter the solar system.
(Vice President Dan Quayle)",
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	$Quote.text = Quotes[rng.randi_range(0, Quotes.size()-1)]
