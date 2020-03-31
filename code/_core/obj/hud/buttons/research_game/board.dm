/obj/hud/button/research/board
	name = "research"
	desc = "Yes, this is research."

	icon = 'icons/hud/game_border.dmi'
	icon_state = "game_border"

	screen_loc = "LEFT,BOTTOM"

	var/list/pieces = new/list(RESEARCH_BOARD_SIZE,RESEARCH_BOARD_SIZE)

	var/list/cleared_pieces = list()

	var/points = 0

	var/level = 1
	var/time_left = 600

	var/obj/hud/button/research/info/time/linked_time
	var/obj/hud/button/research/info/score/linked_score
	var/obj/hud/button/research/info/level/linked_level
	var/obj/hud/button/research/info/text/linked_text
	var/obj/hud/button/research/info/quit/linked_quit

	var/game_initialized = FALSE
	var/init_x = 1
	var/init_y = 1

/obj/hud/button/research/board/think()

	. = ..()

	if(!game_initialized)
		var/obj/hud/button/research/piece/P = new
		P.update_owner(owner)
		P.x_p = init_x
		P.y_p = init_y
		src.pieces[init_x][init_y] = P
		P.linked_board = src
		P.initialize_colors()
		P.update_icon()
		P.update_piece()
		init_x++
		if(init_x > RESEARCH_BOARD_SIZE)
			init_x = 1
			init_y++
			if(init_y > RESEARCH_BOARD_SIZE)
				game_initialized = TRUE
				linked_text.maptext = "<center><font size='3'>Start!</font></center>"
				spawn(20)
					animate(linked_text,alpha=0,time = 10)

	else
		time_left--

		if(linked_time)
			linked_time.maptext = "<center>Time:<br>[get_clock_time(CEILING(time_left/10,1))]</center>"
			if(time_left <= 100)
				linked_time.color = "#FF0000"
				if(time_left <= 50 && !(time_left % 2))
					linked_time.color = "#000000"
			else
				linked_time.color = "#FFFFFF"
			if(time_left <= 0)
				linked_text.alpha = 255

				var/highscore = "HIGH SCORES:"
				for(var/list/v in SSresearch.quadrant_high_scores)
					highscore += "<br>[v[1]]:&nbsp;&nbsp;[v[2]]"

				linked_text.maptext = "<center><font size=10>TIMES UP!</font><br>Final Score: [points].<br><br><br>[highscore]</center>"
				SSresearch.add_quadrants_score(owner,points)
				return FALSE

	return .

/obj/hud/button/research/board/proc/add_points(var/points_to_add)
	level = 1 + FLOOR(points/20,1)
	time_left += (points_to_add)*10
	if(points_to_add >= 2)
		time_left = max(time_left,30)
	points += points_to_add*(1 + FLOOR(level/3,1))
	if(linked_level)
		linked_level.maptext = "<center>Level:<br>[level]</center>"
	if(linked_score)
		linked_score.maptext = "<center>Score:<br>[points]</center>"
		if(points_to_add > 2)
			linked_text.alpha = 255
			linked_text.maptext = "<center><font size=5>Well done!</font></center>"
			play_sound('sounds/ui/friendly.ogg',list(owner),vector(owner.x,owner.y,owner.z),environment = ENVIRONMENT_GENERIC)
			spawn(20)
				animate(linked_text,alpha=0,time = 10)



	return TRUE

/obj/hud/button/research/board/Destroy()

	for(var/x_pos=1,x_pos<=RESEARCH_BOARD_SIZE,x_pos++)
		for(var/y_pos=1,y_pos<=RESEARCH_BOARD_SIZE,y_pos++)
			var/obj/hud/button/research/piece/P = pieces[x_pos][y_pos]
			if(P)
				qdel(P)
			P = null
		pieces[x_pos].Cut()
	pieces.Cut()

	qdel(linked_time)
	linked_time = null

	qdel(linked_score)
	linked_score = null

	qdel(linked_text)
	linked_text = null

	qdel(linked_quit)
	linked_quit = null

	return ..()

/obj/hud/button/research/board/update_owner(var/desired_owner)

	. = ..()

	if(linked_time)
		linked_time.update_owner(desired_owner)
		if(desired_owner == null)
			qdel(linked_time)
			linked_time = null
	else if(desired_owner != null)
		linked_time = new
		linked_time.update_owner(desired_owner)

	if(linked_level)
		linked_level.update_owner(desired_owner)
		if(desired_owner == null)
			qdel(linked_level)
			linked_level = null
	else if(desired_owner != null)
		linked_level = new
		linked_level.update_owner(desired_owner)

	if(linked_score)
		linked_score.update_owner(desired_owner)
		if(desired_owner == null)
			qdel(linked_score)
			linked_score = null
	else if(desired_owner != null)
		linked_score = new
		linked_score.update_owner(desired_owner)

	if(linked_text)
		linked_text.update_owner(desired_owner)
		if(desired_owner == null)
			qdel(linked_text)
			linked_text = null
	else if(desired_owner != null)
		linked_text = new
		linked_text.update_owner(desired_owner)

	if(linked_quit)
		linked_quit.update_owner(desired_owner)
		if(desired_owner == null)
			qdel(linked_quit)
			linked_quit = null
	else if(desired_owner != null)
		linked_quit = new
		linked_quit.update_owner(desired_owner)

	if(desired_owner)
		start_thinking(src)
	else
		stop_thinking(src)

	return .