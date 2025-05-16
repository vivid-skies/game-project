extends Resource

static func set_spinner_ammount(OD: float) -> float:
	assert(OD >= 0 and OD <= 10, "OD cannot be lower than 0 and be higher than 10! The OD was %s" % OD)
	
	var amount: float

	if OD < 5.0: 
		amount = 5.0 - 2.0 * (5.0 - OD) / 5.0
	elif OD == 5: 
		amount = 5.0
	elif OD > 5: 
		amount = 5.0 + 2.5 * (OD - 5.0) / 5.0

	return amount

static func set_hit_window(OD: float) -> Dictionary:
	assert(OD >= 0 and OD <= 10, "OD cannot be lower than 0 and be higher than 10! The OD was %s" % OD)

	var perfect: float = 80.0 - (6.0 * OD)
	var great: float = 140.0 - (8.0 * OD)
	var ok: float = 200.0 - (10.0 * OD)

	# this is just for debugging
	if OD == 3:
		var assDict: Dictionary = { perfect = 62.00, great = 116.00, ok = 170.00 }
		assert(perfect == assDict.perfect + "Perfect calcs do not match up!" + "Perfect: " + perfect + "Assert: " + assDict.perfect)
		assert(great == assDict.great + "Great calcs do not match up!" + "Great: " + great + "Assert: " + assDict.great)
		assert(perfect == assDict.ok + "Ok calcs do not match up!" + "Ok: " + ok + "Assert: " + assDict.ok)

	return {
		perfect = perfect,
		great = great,
		ok = ok,
	}

static func set_circle_size(CS: float) -> float:
	assert(CS >= 2 and CS <= 7, "CS cannot be lower than 2 and be higher than 7! The CS was %s" % CS)

	return 54.4 / 4.48 * CS

static func set_approach_rate(AR: float) -> Dictionary:
	assert(AR > 0 and AR <= 10, "AR cannot be lower than 0 and be higher than 10! The AR was %s" % AR)
	# Approach rate is calculate by X - preempt
	# The hit object starts fading in at X - preempt with:
		# AR < 5: preempt = 1200ms + 600ms * (5 - AR) / 5
		# AR = 5: preempt = 1200ms
		# AR > 5: preempt = 1200ms - 750ms * (AR - 5) / 5

	# The amount of time it takes for the hit object to completely fade in is also reliant on the approach rate:
		# AR < 5: fade_in = 800ms + 400ms * (5 - AR) / 5
		# AR = 5: fade_in = 800ms
		# AR > 5: fade_in = 800ms - 500ms * (AR - 5) / 5

	var preempt: float
	var fade_in: float
	var assVal: float

	if AR < 5.0: 
		preempt = 1200.0 + 600.0 * (5.0 - AR) / 5.0
		fade_in = 800 + 400 * (5.0 - AR) / 5.0

		# Assert if AR is 2
		assVal = 1560.0
		assert(preempt == assVal, "Expected prempt to be  1560.0, but it was %s" % preempt)

	elif AR == 5.0: 
		preempt = 1200.0
		fade_in = 800.0

		# Assert if AR is 5
		assVal = 1200.0
		assert(preempt == assVal, "Expected prempt to be  1200.0, but it was %s" % preempt)
	elif AR > 5.0: 
		preempt = 1200.0 - 750.0 * (AR - 5.0) / 5.0
		fade_in = 800.0 - 500.0 * (AR - 5.0) / 5.0

		# Assert if AR is 7
		assVal = 900.0
		assert(preempt == assVal, "Expected prempt to be  900.0, but it was %s" % preempt)
	
	return {
		preempt = preempt,
		fade_in = fade_in,
	}

static func get_bpm(beat_length: float, time_signature: float) -> float:
	return (time_signature / 4.0) / beat_length * 1000.0 * 60.0
