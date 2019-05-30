import std.array : empty, front;

import xlsxiod;

unittest {
	string[] sn = sheetNames("test0.xlsx");
	assert(!sn.empty);
	assert(sn.front == "sheet_number_one", sn.front);
}
