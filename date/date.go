package date

import (
	"strconv"
	"strings"
)

// Date 简单封装了非闰年的月份和具体日期
type Date struct {
	month, day int
	spliter    rune
}

const _defaultSpliter = '-'

func New(time string) *Date {
	dt := new(Date)
	dt.spliter = _defaultSpliter
	flds := strings.FieldsFunc(time, func(r rune) bool {
		return r == dt.spliter
	})
	dt.month, _ = strconv.Atoi(flds[0])
	dt.day, _ = strconv.Atoi(flds[1])
	return dt
}

// SetSpliter 用于设置日期的分隔符
func (dt *Date) SetSpliter(spt rune) {
	dt.spliter = spt
}

// Sub 返回天数的差值，如果当前日期在减数日期之前，返回 -1
func (dt Date) Sub(anotherDate Date) int {
	if dt.month < anotherDate.month {
		return -1
	}
	if dt.month == anotherDate.month && dt.day < anotherDate.day {
		return -1
	}

	// 被减数
	minuend := countDays(dt.month) + dt.day
	// 减数
	subtrahend := countDays(anotherDate.month) + anotherDate.day

	return minuend - subtrahend
}

// Before 返回当前时间是否在给定时间之前
func (dt Date) Before(anotherDate Date) bool {
	return dt.Sub(anotherDate) < 0
}

// After 返回当前时间是否在给定时间之后
func (dt Date) After(anotherDate Date) bool {
	return dt.Sub(anotherDate) > 0
}

func countDays(month int) (days int) {
	for i := 1; i < month; i++ {
		days += monthsDays[i]
	}
	return
}

var monthsDays = [13]int{
	0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31,
}

const (
	undefind = iota
	January
	February
	March
	April
	May
	June
	July
	Auguest
	September
	October
	November
	December
)
