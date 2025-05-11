extends Node


# const TICKS_PER_DAY: int = 864000000000
# const TICKS_PER_HOUR: int = 36000000000
# const TICKS_PER_MINUTE: int = 600000000
# const TICKS_PER_SECOND: int = 10000000
# const TICKS_PER_MILLISECOND: int = 10000

# const MAX_VALUE = 9223372036854775808

# static var MaxValue: int
# static var MinValue: int
# static var Zero: int = 0

# var ticks: float


const Enums = preload('Enums.gd')
const Utils: Object = preload('Utils.gd')

static func print_test() -> void:
	print(Enums.Event)
