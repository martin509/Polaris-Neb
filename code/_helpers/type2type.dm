/*
 * Holds procs designed to change one type of value, into another.
 * Contains:
 *			text2list & list2text
 *			file2list
 *			angle2dir
 *			angle2text
 *			worldtime2text
 */

// Splits the text of a file at seperator and returns them in a list.
/proc/file2list(filename, seperator = "\n")
	return splittext(safe_file2text(filename), seperator)

// Turns a direction into text
/proc/dir2text(direction)
	switch (direction)
		if (NORTH)     return "north"
		if (SOUTH)     return "south"
		if (EAST)      return "east"
		if (WEST)      return "west"
		if (NORTHEAST) return "northeast"
		if (SOUTHEAST) return "southeast"
		if (NORTHWEST) return "northwest"
		if (SOUTHWEST) return "southwest"
		if (UP)        return "up"
		if (DOWN)      return "down"
	return "unknown ([direction])"

// Turns text into proper directions
/proc/text2dir(direction)
	switch (uppertext(direction))
		if ("NORTH")     return NORTH
		if ("SOUTH")     return SOUTH
		if ("EAST")      return EAST
		if ("WEST")      return WEST
		if ("NORTHEAST") return NORTHEAST
		if ("NORTHWEST") return NORTHWEST
		if ("SOUTHEAST") return SOUTHEAST
		if ("SOUTHWEST") return SOUTHWEST

// Converts an angle (degrees) into an ss13 direction
/proc/angle2dir(var/degree)
	degree = (degree + 22.5) % 360 // 22.5 = 45 / 2
	if (degree < 45)  return NORTH
	if (degree < 90)  return NORTHEAST
	if (degree < 135) return EAST
	if (degree < 180) return SOUTHEAST
	if (degree < 225) return SOUTH
	if (degree < 270) return SOUTHWEST
	if (degree < 315) return WEST
	return NORTH|WEST

// Returns the north-zero clockwise angle in degrees, given a direction
/proc/dir2angle(var/D)
	switch (D)
		if (NORTH)     return 0
		if (SOUTH)     return 180
		if (EAST)      return 90
		if (WEST)      return 270
		if (NORTHEAST) return 45
		if (SOUTHEAST) return 135
		if (NORTHWEST) return 315
		if (SOUTHWEST) return 225

// Returns the angle in english
/proc/angle2text(var/degree)
	return dir2text(angle2dir(degree))

// Converts a blend_mode constant to one acceptable to icon.Blend()
/proc/blendMode2iconMode(blend_mode)
	switch (blend_mode)
		if (BLEND_MULTIPLY) return ICON_MULTIPLY
		if (BLEND_ADD)      return ICON_ADD
		if (BLEND_SUBTRACT) return ICON_SUBTRACT
		else                return ICON_OVERLAY

/proc/iconMode2blendMode(icon_mode)
	switch (icon_mode)
		if (ICON_MULTIPLY) return BLEND_MULTIPLY
		if (ICON_ADD)      return BLEND_ADD
		if (ICON_SUBTRACT) return BLEND_SUBTRACT
		else               return BLEND_OVERLAY

// Converts a rights bitfield into a string
/proc/rights2text(rights,seperator="")
	if (rights & R_BUILDMODE)   . += "[seperator]+BUILDMODE"
	if (rights & R_ADMIN)       . += "[seperator]+ADMIN"
	if (rights & R_BAN)         . += "[seperator]+BAN"
	if (rights & R_FUN)         . += "[seperator]+FUN"
	if (rights & R_SERVER)      . += "[seperator]+SERVER"
	if (rights & R_DEBUG)       . += "[seperator]+DEBUG"
	if (rights & R_POSSESS)     . += "[seperator]+POSSESS"
	if (rights & R_PERMISSIONS) . += "[seperator]+PERMISSIONS"
	if (rights & R_STEALTH)     . += "[seperator]+STEALTH"
	if (rights & R_REJUVENATE)  . += "[seperator]+REJUVENATE"
	if (rights & R_VAREDIT)     . += "[seperator]+VAREDIT"
	if (rights & R_SOUNDS)      . += "[seperator]+SOUND"
	if (rights & R_SPAWN)       . += "[seperator]+SPAWN"
	if (rights & R_MOD)         . += "[seperator]+MODERATOR"
	return .

// heat2color functions. Adapted from: http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
/proc/heat2color(temp)
	return rgb(heat2color_r(temp), heat2color_g(temp), heat2color_b(temp))

/proc/heat2color_r(temp)
	temp /= 100
	if(temp <= 66)
		. = 255
	else
		. = max(0, min(255, 329.698727446 * (temp - 60) ** -0.1332047592))

/proc/heat2color_g(temp)
	temp /= 100
	if(temp <= 66)
		. = max(0, min(255, 99.4708025861 * log(temp) - 161.1195681661))
	else
		. = max(0, min(255, 288.1221695283 * ((temp - 60) ** -0.0755148492)))

/proc/heat2color_b(temp)
	temp /= 100
	if(temp >= 66)
		. = 255
	else
		if(temp <= 16)
			. = 0
		else
			. = max(0, min(255, 138.5177312231 * log(temp - 10) - 305.0447927307))

// Very ugly, BYOND doesn't support unix time and rounding errors make it really hard to convert it to BYOND time.
// returns "YYYY-MM-DD" by default
/proc/unix2date(timestamp, seperator = "-")
	if(timestamp < 0)
		return 0 //Do not accept negative values

	var/const/dayInSeconds = 86400 //60secs*60mins*24hours
	var/const/daysInYear = 365 //Non Leap Year
	var/const/daysInLYear = daysInYear + 1//Leap year
	var/days = round(timestamp / dayInSeconds) //Days passed since UNIX Epoc
	var/year = 1970 //Unix Epoc begins 1970-01-01
	var/tmpDays = days + 1 //If passed (timestamp < dayInSeconds), it will return 0, so add 1
	var/monthsInDays = list() //Months will be in here ***Taken from the PHP source code***
	var/month = 1 //This will be the returned MONTH NUMBER.
	var/day //This will be the returned day number.

	while(tmpDays > daysInYear) //Start adding years to 1970
		year++
		if(isLeap(year))
			tmpDays -= daysInLYear
		else
			tmpDays -= daysInYear

	if(isLeap(year)) //The year is a leap year
		monthsInDays = list(-1,30,59,90,120,151,181,212,243,273,304,334)
	else
		monthsInDays = list(0,31,59,90,120,151,181,212,243,273,304,334)

	var/mDays = 0;
	var/monthIndex = 0;

	for(var/m in monthsInDays)
		monthIndex++
		if(tmpDays > m)
			mDays = m
			month = monthIndex

	day = tmpDays - mDays //Setup the date

	return "[year][seperator][((month < 10) ? "0[month]" : month)][seperator][((day < 10) ? "0[day]" : day)]"

/proc/isLeap(y)
	return ((y) % 4 == 0 && ((y) % 100 != 0 || (y) % 400 == 0))

/proc/atomtypes2nameassoclist(var/list/atom_types)
	. = list()
	for(var/atom_type in atom_types)
		var/atom/A = atom_type
		.[initial(A.name)] = atom_type
	. = sortTim(., /proc/cmp_text_asc)

/proc/atomtype2nameassoclist(var/atom_type)
	return atomtypes2nameassoclist(typesof(atom_type))

//checks if a file exists and contains text
//returns text as a string if these conditions are met
/proc/safe_file2text(filename, error_on_invalid_return = TRUE)
	try
		if(fexists(filename))
			. = file2text(filename)
			if(!. && error_on_invalid_return)
				error("File empty ([filename])")
		else if(error_on_invalid_return)
			error("File not found ([filename])")
	catch(var/exception/E)
		if(error_on_invalid_return)
			error("Exception when loading file as string: [EXCEPTION_TEXT(E)]")
