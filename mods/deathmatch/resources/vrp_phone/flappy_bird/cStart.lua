function toggleFlappyBird(state)
	if state then
		flappyBirdGame	= FlappyBirdGame:New();
		flappyShow = true
	else
		if flappyBirdGame then
			flappyBirdGame:Destructor();
			flappyBirdGame = false
		end
		flappyShow = false
	end
end
