
const TICKS_PER_DAY: int = 864000000000
const TICKS_PER_HOUR: int = 36000000000
const TICKS_PER_MINUTE: int = 600000000
const TICKS_PER_SECOND: int = 10000000
const TICKS_PER_MILLISECOND: int = 10000

const MAX_VALUE = 9223372036854775808

static var MaxValue: int
static var MinValue: int
static var Zero: int = 0

var ticks: float

# func _init(p_MaxValue: int = MAX_VALUE) -> void:
# 	MaxValue = p_MaxValue
# 	MinValue = -p_MaxValue

# var milliseconds: int:
# 	get: 
# 		return float(int(ticks) % TICKS_PER_SECOND) / TICKS_PER_MILLISECOND
# var seconds: int
# var minutes: int
# var hours: int
# var days: int
# var total_minutes: float
# var total_seconds: float



# func total_days() -> float:
# 	return ticks / TICKS_PER_DAY

